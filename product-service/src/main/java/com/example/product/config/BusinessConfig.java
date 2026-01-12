package com.example.product.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.stereotype.Component;

@Component
@RefreshScope  // 支持动态刷新
public class BusinessConfig {

    @Value("${business.max-page-size:50}")
    private Integer maxPageSize;

    @Value("${business.discount-enabled:false}")
    private Boolean discountEnabled;

    public Integer getMaxPageSize() {
        return maxPageSize;
    }

    public Boolean getDiscountEnabled() {
        return discountEnabled;
    }
}
