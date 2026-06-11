#!/usr/bin/env python3
"""bian-platform service generator.

Reads catalog/bian-service-landscape.json and stamps one independent git repo
per BIAN Service Domain (Netflix-style multi-repo) from templates/service/.

Usage:
    python3 generate.py                 # stamp all missing repos
    python3 generate.py --force         # re-stamp everything (overwrites boilerplate)
    python3 generate.py --only current-account payment-order
    python3 generate.py --dry-run       # show what would be generated

Stdlib only — no dependencies. Deterministic: same catalog in, same repos out.
"""

from __future__ import annotations

import argparse
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
CATALOG = HERE.parent / "catalog" / "bian-service-landscape.json"
TEMPLATE = HERE / "templates" / "service"
DEFAULT_OUT = HERE.parent.parent / "bian-services"

COMMIT_MESSAGE = (
    "Initial commit: generated BIAN service domain '{sd}'\n\n"
    "Stamped by bian-platform/generator (Phase 1 — shallow build).\n\n"
    "Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
)

RESTAMP_MESSAGE = (
    "Re-stamp from golden template\n\n"
    "Boilerplate refresh via bian-platform/generator --force.\n\n"
    "Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
)

# BIAN-style control-record naming: functional pattern -> generic artifact noun.
# e.g. Current Account (Fulfill, "Current Account Facility")
#      -> control record "Current Account Facility Fulfillment Arrangement"
PATTERN_NOUN = {
    "Direct": "Strategy",
    "Manage": "Management Plan",
    "Administer": "Administrative Plan",
    "Process": "Procedure",
    "Operate": "Operating Session",
    "Maintain": "Maintenance Agreement",
    "Catalog": "Directory Entry",
    "Develop": "Development Project",
    "Design": "Design",
    "Provide Advice": "Advisory Session",
    "Monitor": "Monitoring State",
    "Track": "Tracking Position",
    "Fulfill": "Fulfillment Arrangement",
    "Transact": "Transaction",
    "Register": "Registration",
    "Allocate": "Allocation",
    "Analyze": "Analysis",
    "Assess": "Assessment",
    "Distribute": "Distribution",
    "Plan": "Plan",
}

# One K8s namespace per BIAN business area.
AREA_NAMESPACE = {
    "Reference Data": "bian-reference-data",
    "Sales and Service": "bian-sales-service",
    "Operations and Execution": "bian-operations",
    "Risk and Compliance": "bian-risk-compliance",
    "Business Support": "bian-business-support",
}


def slug(text: str) -> str:
    return re.sub(r"-+", "-", re.sub(r"[^a-z0-9]+", "-", text.lower())).strip("-")


def package_segment(text: str) -> str:
    return re.sub(r"[^a-z0-9]", "", text.lower())


def build_context(area: str, domain: str, sd: dict) -> dict:
    name = sd["name"]
    pattern = sd["functionalPattern"]
    asset = sd["assetType"]
    sd_slug = slug(name)
    control_record = f"{asset} {PATTERN_NOUN[pattern]}"
    return {
        "__SD_NAME__": name,
        "__SD_SLUG__": sd_slug,
        "__ARTIFACT_ID__": f"sd-{sd_slug}",
        "__PACKAGE__": f"com.bank.bian.{package_segment(name)}",
        "__BUSINESS_AREA__": area,
        "__BUSINESS_AREA_SLUG__": slug(area),
        "__BUSINESS_DOMAIN__": domain,
        "__BUSINESS_DOMAIN_SLUG__": slug(domain),
        "__FUNCTIONAL_PATTERN__": pattern,
        "__FUNCTIONAL_PATTERN_SLUG__": slug(pattern),
        "__ASSET_TYPE__": asset,
        "__CONTROL_RECORD__": control_record,
        "__CR_SLUG__": slug(control_record),
        "__NAMESPACE__": AREA_NAMESPACE[area],
    }


def substitute(text: str, ctx: dict) -> str:
    for key, value in ctx.items():
        text = text.replace(key, value)
    return text


def stamp(repo_dir: Path, ctx: dict) -> None:
    pkg_path = ctx["__PACKAGE__"].replace(".", "/")
    for src in sorted(TEMPLATE.rglob("*")):
        if not src.is_file():
            continue
        rel = src.relative_to(TEMPLATE).as_posix()
        rel = rel.replace("__JAVA_TEST__", f"src/test/java/{pkg_path}")
        rel = rel.replace("__JAVA__", f"src/main/java/{pkg_path}")
        rel = substitute(rel, ctx)
        dest = repo_dir / rel
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_text(substitute(src.read_text(), ctx))


def git_commit(repo_dir: Path, sd_name: str) -> None:
    def run(*args: str) -> None:
        subprocess.run(["git", *args], cwd=repo_dir, check=True, capture_output=True)

    fresh = not (repo_dir / ".git").exists()
    if fresh:
        run("init", "-q", "-b", "main")
    has_head = not fresh and subprocess.run(
        ["git", "rev-parse", "-q", "--verify", "HEAD"],
        cwd=repo_dir, capture_output=True).returncode == 0
    run("add", "-A")
    status = subprocess.run(["git", "status", "--porcelain"], cwd=repo_dir,
                            check=True, capture_output=True, text=True)
    if status.stdout.strip():
        msg = RESTAMP_MESSAGE if has_head else COMMIT_MESSAGE.format(sd=sd_name)
        run("commit", "-q", "-m", msg)


def iter_service_domains(catalog: dict):
    for area in catalog["businessAreas"]:
        for domain in area["businessDomains"]:
            for sd in domain["serviceDomains"]:
                yield area["name"], domain["name"], sd


def write_registry(out_dir: Path, entries: list[dict]) -> None:
    (out_dir / "registry.json").write_text(json.dumps(
        {"generatedFrom": "bian-platform/catalog/bian-service-landscape.json",
         "count": len(entries), "services": entries}, indent=2) + "\n")

    lines = [
        "# BIAN Service Registry",
        "",
        f"**{len(entries)} service domains**, one repo each, stamped by `bian-platform/generator`.",
        "",
        "| Repo | Service Domain | Business Area | Pattern | Namespace | Gateway path |",
        "|---|---|---|---|---|---|",
    ]
    for e in entries:
        lines.append(
            f"| `{e['repo']}` | {e['serviceDomain']} | {e['businessArea']} "
            f"| {e['functionalPattern']} | `{e['namespace']}` | `/{e['repo']}` |")
    (out_dir / "REGISTRY.md").write_text("\n".join(lines) + "\n")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--out", type=Path, default=DEFAULT_OUT)
    parser.add_argument("--force", action="store_true",
                        help="re-stamp repos that already exist (git history is preserved)")
    parser.add_argument("--only", nargs="*", default=None,
                        help="service-domain slugs to generate (default: all)")
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--no-git", action="store_true", help="skip git init/commit")
    args = parser.parse_args()

    catalog = json.loads(CATALOG.read_text())
    args.out.mkdir(parents=True, exist_ok=True)

    entries, created, updated, skipped = [], 0, 0, 0
    for area, domain, sd in iter_service_domains(catalog):
        if sd["functionalPattern"] not in PATTERN_NOUN:
            print(f"ERROR: unknown functional pattern '{sd['functionalPattern']}' on '{sd['name']}'",
                  file=sys.stderr)
            return 1
        ctx = build_context(area, domain, sd)
        if args.only and ctx["__SD_SLUG__"] not in args.only:
            continue
        repo_dir = args.out / ctx["__ARTIFACT_ID__"]
        entries.append({
            "repo": ctx["__ARTIFACT_ID__"],
            "serviceDomain": sd["name"],
            "businessArea": area,
            "businessDomain": domain,
            "functionalPattern": sd["functionalPattern"],
            "assetType": sd["assetType"],
            "controlRecord": ctx["__CONTROL_RECORD__"],
            "namespace": ctx["__NAMESPACE__"],
            "package": ctx["__PACKAGE__"],
        })

        exists = repo_dir.exists()
        if exists and not args.force:
            skipped += 1
            continue
        if args.dry_run:
            print(f"would stamp: {repo_dir}")
            continue
        stamp(repo_dir, ctx)
        if not args.no_git:
            git_commit(repo_dir, sd["name"])
        created += 0 if exists else 1
        updated += 1 if exists else 0

    if not args.dry_run and not args.only:
        write_registry(args.out, entries)

    print(f"done: {created} created, {updated} re-stamped, {skipped} skipped "
          f"(already exist; use --force) · registry: {len(entries)} entries")
    return 0


if __name__ == "__main__":
    sys.exit(main())
