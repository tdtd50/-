package com.example.user.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.stereotype.Component;

@Component
@RefreshScope  // 支持动态刷新
public class BusinessConfig {

    @Value("${business.max-page-size:100}")
    private Integer maxPageSize;

    @Value("${business.feature-enabled:false}")
    private Boolean featureEnabled;

    public Integer getMaxPageSize() {
        return maxPageSize;
    }

    public Boolean getFeatureEnabled() {
        return featureEnabled;
    }
}
