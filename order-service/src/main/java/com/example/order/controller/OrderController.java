package com.example.order.controller;

import com.example.order.model.Order;
import com.example.order.service.OrderService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/orders")
public class OrderController {

    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @PostMapping
    public Order create(@RequestBody Order order) {
        return orderService.create(order);
    }

    @GetMapping("/{id}")
    public Order get(@PathVariable Long id) {
        return orderService.getById(id);
    }
}
