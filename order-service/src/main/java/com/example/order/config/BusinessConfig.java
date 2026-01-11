package com.example.order.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.stereotype.Component;

@Component
@RefreshScope  // 支持动态刷新
public class BusinessConfig {

    @Value("${business.max-page-size:20}")
    private Integer maxPageSize;

    @Value("${business.auto-confirm-enabled:false}")
    private Boolean autoConfirmEnabled;

    public Integer getMaxPageSize() {
        return maxPageSize;
    }

    public Boolean getAutoConfirmEnabled() {
        return autoConfirmEnabled;
    }
}
