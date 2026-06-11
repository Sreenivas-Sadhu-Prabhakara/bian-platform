package __PACKAGE__.model;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * The BIAN control record for this service domain: "__CONTROL_RECORD__".
 *
 * In BIAN, every Service Domain manages exactly one control record type whose
 * shape follows the domain's functional pattern (__FUNCTIONAL_PATTERN__) applied
 * to its asset type (__ASSET_TYPE__). Phase 1 keeps a generic, shallow shape;
 * Phase 2 specializes it per domain.
 */
public class ControlRecord {

    public enum Status { INITIATED, ACTIVE, SUSPENDED, TERMINATED }

    private String controlRecordId;
    private final String controlRecordType = "__CONTROL_RECORD__";
    private Status status = Status.INITIATED;
    private Instant createdAt = Instant.now();
    private Instant updatedAt = Instant.now();
    /** Free-form domain properties until Phase 2 introduces the real schema. */
    private Map<String, Object> properties = new LinkedHashMap<>();

    public String getControlRecordId() { return controlRecordId; }
    public void setControlRecordId(String controlRecordId) { this.controlRecordId = controlRecordId; }

    public String getControlRecordType() { return controlRecordType; }

    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }

    public Instant getCreatedAt() { return createdAt; }
    public void setCreatedAt(Instant createdAt) { this.createdAt = createdAt; }

    public Instant getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Instant updatedAt) { this.updatedAt = updatedAt; }

    public Map<String, Object> getProperties() { return properties; }
    public void setProperties(Map<String, Object> properties) {
        this.properties = properties == null ? new LinkedHashMap<>() : properties;
    }
}
