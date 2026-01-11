package com.example.product.controller;

import com.example.product.config.BusinessConfig;
import org.springframework.web.bind.annotation.GetMapping;
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
        config.put("discountEnabled", businessConfig.getDiscountEnabled());
        config.put("timestamp", System.currentTimeMillis());
        return config;
    }
}
