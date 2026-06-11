package __PACKAGE__.service;

import __PACKAGE__.model.ControlRecord;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.Collection;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Phase 1: in-memory store so every service domain deploys and answers real
 * requests with zero external dependencies. Phase 2 swaps this for per-domain
 * persistence (one database per service — decentralized data, Netflix-style).
 */
@Service
public class ControlRecordStore {

    private final Map<String, ControlRecord> records = new ConcurrentHashMap<>();

    public ControlRecord initiate(Map<String, Object> properties) {
        ControlRecord cr = new ControlRecord();
        cr.setControlRecordId("CR-" + UUID.randomUUID());
        if (properties != null) {
            cr.setProperties(properties);
        }
        cr.setStatus(ControlRecord.Status.ACTIVE);
        records.put(cr.getControlRecordId(), cr);
        return cr;
    }

    public Collection<ControlRecord> list() {
        return records.values();
    }

    public Optional<ControlRecord> retrieve(String id) {
        return Optional.ofNullable(records.get(id));
    }

    public Optional<ControlRecord> update(String id, Map<String, Object> properties) {
        return retrieve(id).map(cr -> {
            if (properties != null) {
                cr.getProperties().putAll(properties);
            }
            cr.setUpdatedAt(Instant.now());
            return cr;
        });
    }

    public Optional<ControlRecord> control(String id, String action) {
        return retrieve(id).map(cr -> {
            switch (action == null ? "" : action.toLowerCase()) {
                case "suspend" -> cr.setStatus(ControlRecord.Status.SUSPENDED);
                case "resume" -> cr.setStatus(ControlRecord.Status.ACTIVE);
                case "terminate" -> cr.setStatus(ControlRecord.Status.TERMINATED);
                default -> throw new IllegalArgumentException(
                        "Unknown control action '" + action + "' — use suspend | resume | terminate");
            }
            cr.setUpdatedAt(Instant.now());
            return cr;
        });
    }
}
