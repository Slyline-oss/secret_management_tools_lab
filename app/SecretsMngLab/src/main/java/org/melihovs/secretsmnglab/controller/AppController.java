package org.melihovs.secretsmnglab.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.LinkedHashMap;
import java.util.Map;

@RestController
public class AppController {
    @Value("${spring.datasource.url:undefined}")
    private String datasourceUrl;

    @GetMapping("/health")
    public Map<String, Object> health() {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("status", "UP");
        response.put("application", "secret-lab-app");
        response.put("javaVersion", System.getProperty("java.version"));
        return response;
    }

    @GetMapping("/config-info")
    public Map<String, Object> configInfo() {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("datasourceUrl", datasourceUrl);
        response.put("note", "Scenario 1 will later intentionally include insecure secret handling.");
        return response;
    }
}
