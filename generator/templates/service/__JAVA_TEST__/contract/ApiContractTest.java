package __PACKAGE__.contract;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.yaml.snakeyaml.Yaml;

import java.io.FileReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * CONTRACT TEST — enforces ADR-0003 (contract-per-repo): the repo-owned
 * design-time contract (api/openapi.yaml) and the RUNTIME API (/v3/api-docs)
 * must describe the same surface. Bidirectional:
 *
 *   1. every contract operation exists at runtime  (no vaporware in the contract)
 *   2. every runtime operation exists in the contract (no undocumented endpoints)
 *   3. parameter-less GET operations are live-probed and must answer with a
 *      status code the contract documents
 *   4. the event contract (api/events.yaml) parses and has the required shape
 *
 * Path parameters are compared structurally ({accountId} ≡ {crId} ≡ {}).
 * This file is template-owned for generated repos and copied (package-adjusted)
 * into graduated repos — the discipline is identical for both.
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class ApiContractTest {

    private static final Set<String> HTTP_METHODS =
            Set.of("get", "post", "put", "delete", "patch", "head", "options");

    @LocalServerPort
    int port;

    @Autowired
    TestRestTemplate rest;

    private Map<String, Object> contract;
    private JsonNode runtime;

    @BeforeAll
    @SuppressWarnings("unchecked")
    void load() throws Exception {
        assertThat(Files.exists(Path.of("api/openapi.yaml")))
                .as("api/openapi.yaml must exist — contracts live per repo (ADR-0003)")
                .isTrue();
        contract = new Yaml().load(new FileReader("api/openapi.yaml"));
        String docs = rest.getForObject("http://localhost:" + port + "/v3/api-docs", String.class);
        runtime = new ObjectMapper().readTree(docs);
    }

    /** "/x/{accountId}/y" -> "/x/{}/y" so param names don't matter, structure does. */
    private static String normalize(String path) {
        return path.replaceAll("\\{[^}]+}", "{}");
    }

    @SuppressWarnings("unchecked")
    private Set<String> contractOperations() {
        Set<String> ops = new TreeSet<>();
        Map<String, Object> paths = (Map<String, Object>) contract.get("paths");
        paths.forEach((path, item) -> ((Map<String, Object>) item).forEach((k, v) -> {
            if (HTTP_METHODS.contains(k)) {
                ops.add(k.toUpperCase() + " " + normalize(path));
            }
        }));
        return ops;
    }

    private Set<String> runtimeOperations() {
        Set<String> ops = new TreeSet<>();
        runtime.path("paths").fields().forEachRemaining(e ->
                e.getValue().fieldNames().forEachRemaining(m -> {
                    if (HTTP_METHODS.contains(m)) {
                        ops.add(m.toUpperCase() + " " + normalize(e.getKey()));
                    }
                }));
        return ops;
    }

    @Test
    void contractIsValidOpenApi3() {
        assertThat(String.valueOf(contract.get("openapi"))).startsWith("3.");
        Map<?, ?> info = (Map<?, ?>) contract.get("info");
        assertThat(String.valueOf(info.get("title"))).isNotBlank();
        assertThat(contract.get("paths")).isNotNull();
    }

    @Test
    void everyContractOperationExistsAtRuntime() {
        Set<String> missing = new TreeSet<>(contractOperations());
        missing.removeAll(runtimeOperations());
        assertThat(missing)
                .as("operations promised by api/openapi.yaml but absent from the running service")
                .isEmpty();
    }

    @Test
    void everyRuntimeOperationIsDocumentedInTheContract() {
        Set<String> undocumented = new TreeSet<>(runtimeOperations());
        undocumented.removeAll(contractOperations());
        assertThat(undocumented)
                .as("endpoints served at runtime but missing from api/openapi.yaml — document or remove them")
                .isEmpty();
    }

    @Test
    @SuppressWarnings("unchecked")
    void parameterlessGetOperationsAnswerWithDocumentedStatus() {
        Map<String, Object> paths = (Map<String, Object>) contract.get("paths");
        int probed = 0;
        for (Map.Entry<String, Object> e : paths.entrySet()) {
            String path = e.getKey();
            Map<String, Object> item = (Map<String, Object>) e.getValue();
            if (path.contains("{") || !item.containsKey("get")) {
                continue;
            }
            Map<String, Object> op = (Map<String, Object>) item.get("get");
            Set<String> documented = ((Map<String, Object>) op.get("responses")).keySet();
            int status = rest.getForEntity("http://localhost:" + port + path, String.class)
                    .getStatusCode().value();
            assertThat(documented)
                    .as("GET %s answered %d — a status the contract does not document", path, status)
                    .contains(String.valueOf(status));
            probed++;
        }
        assertThat(probed).as("at least the collection + metadata GETs must be probeable").isGreaterThanOrEqualTo(2);
    }

    @Test
    @SuppressWarnings("unchecked")
    void eventContractParsesAndHasRequiredShape() throws Exception {
        assertThat(Files.exists(Path.of("api/events.yaml")))
                .as("api/events.yaml must exist — event contracts live per repo")
                .isTrue();
        Map<String, Object> events = new Yaml().load(new FileReader("api/events.yaml"));
        assertThat(events).containsKeys("service", "publishes", "consumes");
        assertThat(String.valueOf(events.get("service"))).startsWith("sd-");
        for (Object t : (List<Object>) events.get("publishes")) {
            Map<String, Object> topic = (Map<String, Object>) t;
            assertThat(topic).as("each publish entry needs topic + events").containsKeys("topic", "events");
            assertThat(String.valueOf(topic.get("topic"))).startsWith("bian.");
        }
    }
}
