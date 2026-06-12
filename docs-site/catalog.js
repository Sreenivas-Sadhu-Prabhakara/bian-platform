/* The Master Catalog — interactivity. Renders CATALOG (catalog-data.js)
   as a searchable, filterable ledger. Vanilla JS; degrades to the printable
   edition link if scripts are unavailable. */
(function () {
  "use strict";
  const $ = (s) => document.querySelector(s);
  const ledger = $("#ledger");
  const q = $("#q"), fArea = $("#f-area"), fKind = $("#f-kind"), fDeep = $("#f-deep");
  const ghRepo = (r) => `https://github.com/${GH_OWNER}/${r}`;
  const ROMAN = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"];

  // populate filters
  [...new Set(CATALOG.map((s) => s.area))].forEach((a) =>
    fArea.insertAdjacentHTML("beforeend", `<option>${a}</option>`));
  [...new Set(CATALOG.map((s) => s.kind))].sort().forEach((k) =>
    fKind.insertAdjacentHTML("beforeend", `<option>${k}</option>`));

  const deepCount = CATALOG.filter((s) => s.deep).length;
  $("#front-counts").innerHTML =
    `<b>${CATALOG.length}</b> service domains · <b>${deepCount}</b> deep builds · ` +
    `<b>${new Set(CATALOG.map((s) => s.area)).size}</b> business areas`;

  function leaf(s) {
    return `
<details class="leaf" data-repo="${s.repo}">
  <summary>
    <span class="open-mark">❧</span>
    <span class="leaf-name">${s.name}</span>
    ${s.deep ? '<span class="leaf-badge">Deep build</span>' : ""}
    <span class="leaf-meta">${s.pattern} · ${s.domain}</span>
  </summary>
  <div class="leaf-body">
    <p class="leaf-what">The system of record for <em>${s.asset}</em> — a ${s.pattern}-pattern
    service domain operating on the <em>${s.cr}</em> control record.</p>
    <p class="leaf-sect">Line of banking</p>
    <p class="leaf-what">${s.kind}</p>
    <p class="leaf-sect">In service of</p>
    <ol>${s.cases.map((c) => `<li>${c}</li>`).join("")}</ol>
    <p class="leaf-sect">Houses with which it transacts</p>
    <ul>${s.providers.map((p) => `<li>${p}</li>`).join("")}</ul>
    <div class="leaf-row">
      <span class="leaf-repo"><a href="${ghRepo(s.repo)}" target="_blank" rel="noopener">${s.repo} ↗</a></span>
      <span>namespace ${s.ns}</span>
      <span>gateway /${s.repo}</span>
    </div>
  </div>
</details>`;
  }

  function render() {
    const term = q.value.trim().toLowerCase();
    const rows = CATALOG.filter((s) =>
      (!term || (s.name + " " + s.repo + " " + s.cr + " " + s.domain + " " + s.kind + " "
        + s.cases.join(" ") + " " + s.providers.join(" ")).toLowerCase().includes(term)) &&
      (!fArea.value || s.area === fArea.value) &&
      (!fKind.value || s.kind === fKind.value) &&
      (!fDeep.checked || s.deep));

    $("#count").textContent = `${rows.length} of ${CATALOG.length} entries`;
    if (!rows.length) {
      ledger.innerHTML = `<p class="nothing">No entry in the catalog answers that description.</p>`;
      return;
    }
    // group: area → domain
    const areas = new Map();
    rows.forEach((s) => {
      if (!areas.has(s.area)) areas.set(s.area, new Map());
      const d = areas.get(s.area);
      if (!d.has(s.domain)) d.set(s.domain, []);
      d.get(s.domain).push(s);
    });
    let html = "", i = 0;
    for (const [area, domains] of areas) {
      html += `<h2 class="area-head"><span class="folio">${ROMAN[i++] || i}</span>${area}</h2>`;
      for (const [domain, ss] of domains) {
        html += `<h3 class="domain-head">${domain} <span class="domain-kind">— ${ss[0].kind}</span></h3>`;
        html += ss.map(leaf).join("");
      }
    }
    ledger.innerHTML = html;
  }

  [q, fArea, fKind, fDeep].forEach((el) =>
    el.addEventListener(el === q ? "input" : "change", render));
  render();
})();
