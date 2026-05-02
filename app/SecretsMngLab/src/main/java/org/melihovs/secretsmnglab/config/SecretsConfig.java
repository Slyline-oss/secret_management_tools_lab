package org.melihovs.secretsmnglab.config;

import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class SecretsConfig {


    private static final Logger log = LoggerFactory.getLogger(SecretsConfig.class);

    @Value("${app.jwt.secret}")

    private String jwtSecret;

    @Value("${app.api.key}")

    private String apiKey;

    @Value("${app.internal-token.token}")

    private String internalToken;

    public String getJwtSecret() {

        return jwtSecret;

    }

    public String getApiKey() {

        return apiKey;

    }

    public String getInternalToken() {

        return internalToken;

    }

    @PostConstruct
    public void logSecrets() {
        log.info("=== Secrets demonstration (masked) ===");
        log.info("JWT secret: {}", mask(jwtSecret));
        log.info("API key: {}", mask(apiKey));
        log.info("Internal token: {}", mask(internalToken));
        log.info("======================================");

    }

    private String mask(String value) {

        if (value == null || value.isEmpty()) return "<empty>";

        int visible = Math.min(4, value.length());

        return value.substring(0, visible) + "****(len=" + value.length() + ")";

    }
}