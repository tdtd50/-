package com.example.user.controller;

import com.example.user.config.BusinessConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
public class ConfigController {

    private final BusinessConfig businessConfig;

    public ConfigController(BusinessConfig businessConfig) {
        this.businessConfig = businessConfig;
    }

    @GetMapping("/config")
    public Map<String, Object> getConfig() {
        Map<String, Object> config = new HashMap<>();
        config.put("maxPageSize", businessConfig.getMaxPageSize());
        config.put("featureEnabled", businessConfig.getFeatureEnabled());
        config.put("timestamp", System.currentTimeMillis());
        return config;
    }
}
