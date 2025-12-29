package com.example.order.service;

import com.example.order.feign.ProductClient;
import com.example.order.feign.UserClient;
import com.example.order.model.Order;
import com.example.order.repository.OrderRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Map;

@Service
public class OrderService {

    private final OrderRepository orderRepository;
    private final UserClient userClient;
    private final ProductClient productClient;

    public OrderService(OrderRepository orderRepository,
                        UserClient userClient,
                        ProductClient productClient) {
        this.orderRepository = orderRepository;
        this.userClient = userClient;
        this.productClient = productClient;
    }

    public Order create(Order order) {

        // 1. 调用 user-service
        Object user = userClient.getUserById(order.getUserId());

        // 2. 调用 product-service
        Map product = (Map) productClient.getProductById(order.getProductId());

        // 3. 计算总价（price * quantity）
        BigDecimal price = new BigDecimal(product.get("price").toString());
        order.setTotalPrice(price.multiply(
                BigDecimal.valueOf(order.getQuantity())
        ));

        return orderRepository.save(order);
    }

    public Order getById(Long id) {
        return orderRepository.findById(id).orElse(null);
    }
}
