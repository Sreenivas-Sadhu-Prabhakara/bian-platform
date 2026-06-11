package __PACKAGE__.api;

import __PACKAGE__.model.ControlRecord;
import __PACKAGE__.service.ControlRecordStore;
import io.github.resilience4j.circuitbreaker.annotation.CircuitBreaker;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collection;
import java.util.Map;

/**
 * BIAN semantic API for the "__SD_NAME__" service domain.
 *
 * Endpoints follow the BIAN action-term style:
 *   GET  /v1/service-domain                          → who am I (SD metadata)
 *   POST /v1/__CR_SLUG__/initiate                    → Initiate a control record
 *   GET  /v1/__CR_SLUG__                             → Retrieve (list)
 *   GET  /v1/__CR_SLUG__/{crId}/retrieve             → Retrieve (single)
 *   PUT  /v1/__CR_SLUG__/{crId}/update               → Update
 *   PUT  /v1/__CR_SLUG__/{crId}/control              → Control (suspend|resume|terminate)
 */
@RestController
@RequestMapping("/v1")
public class ServiceDomainController {

    private final ControlRecordStore store;

    public ServiceDomainController(ControlRecordStore store) {
        this.store = store;
    }

    @GetMapping("/service-domain")
    public Map<String, String> serviceDomain() {
        return Map.of(
                "serviceDomain", "__SD_NAME__",
                "businessArea", "__BUSINESS_AREA__",
                "businessDomain", "__BUSINESS_DOMAIN__",
                "functionalPattern", "__FUNCTIONAL_PATTERN__",
                "assetType", "__ASSET_TYPE__",
                "controlRecord", "__CONTROL_RECORD__",
                "version", "0.1.0",
                "phase", "1-shallow"
        );
    }

    @PostMapping("/__CR_SLUG__/initiate")
    @CircuitBreaker(name = "serviceDomain")
    public ResponseEntity<ControlRecord> initiate(@RequestBody(required = false) Map<String, Object> properties) {
        return ResponseEntity.status(HttpStatus.CREATED).body(store.initiate(properties));
    }

    @GetMapping("/__CR_SLUG__")
    public Collection<ControlRecord> list() {
        return store.list();
    }

    @GetMapping("/__CR_SLUG__/{crId}/retrieve")
    public ResponseEntity<ControlRecord> retrieve(@PathVariable String crId) {
        return store.retrieve(crId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/__CR_SLUG__/{crId}/update")
    public ResponseEntity<ControlRecord> update(@PathVariable String crId,
                                                @RequestBody Map<String, Object> properties) {
        return store.update(crId, properties)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/__CR_SLUG__/{crId}/control")
    public ResponseEntity<?> control(@PathVariable String crId,
                                     @RequestBody Map<String, String> body) {
        try {
            return store.control(crId, body.get("action"))
                    .<ResponseEntity<?>>map(ResponseEntity::ok)
                    .orElse(ResponseEntity.notFound().build());
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}
