# 性能测试报告

## 测试环境

**硬件配置：**
- CPU: Intel Core i7-10700K @ 3.80GHz (8核16线程)
- 内存: 16GB DDR4 3200MHz
- 磁盘: 512GB NVMe SSD

**软件版本：**
- 操作系统: Windows 11 专业版
- Docker 版本: Docker Desktop 4.25.0
- 测试工具: Apache JMeter 5.6.2 / wrk 4.2.0

---

## 测试场景

### 场景 1：用户服务压力测试

**测试参数：**
- 并发用户数：100
- 测试时长：60 秒
- 请求路径：GET /api/v1/users

**测试命令：**
```bash
wrk -t 4 -c 100 -d 60s http://localhost:8080/api/v1/users
```

**测试结果：**
```
Running 60s test @ http://localhost:8080/api/v1/users
  4 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    45.23ms   12.45ms  180.32ms   78.56%
    Req/Sec   550.23     89.45    750.00    82.34%
  132456 requests in 60.00s, 25.34MB read
Requests/sec:   2207.60
Transfer/sec:    432.15KB
```

**性能指标分析：**
- 平均响应时间: 45.23ms
- 吞吐量: 2207.60 req/s
- 成功率: 100%
- P99 延迟: < 180ms

---

### 场景 2：产品服务压力测试

**测试参数：**
- 并发用户数：100
- 测试时长：60 秒
- 请求路径：GET /api/v1/products

**测试命令：**
```bash
wrk -t 4 -c 100 -d 60s http://localhost:8080/api/v1/products
```

**测试结果：**
```
Running 60s test @ http://localhost:8080/api/v1/products
  4 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    38.67ms   10.23ms  156.78ms   75.32%
    Req/Sec   640.18     95.67    820.00    79.45%
  153678 requests in 60.00s, 31.25MB read
Requests/sec:   2561.30
Transfer/sec:    533.89KB
```

**性能指标分析：**
- 平均响应时间: 38.67ms
- 吞吐量: 2561.30 req/s
- 成功率: 100%
- P99 延迟: < 157ms

---

### 场景 3：订单创建混合压力测试

**测试参数：**
- 并发用户数：50
- 测试时长：60 秒
- 请求路径：POST /api/v1/orders

**测试说明：**
订单创建涉及跨服务调用（用户服务 + 产品服务），负载较高。

**测试命令：**
```bash
wrk -t 4 -c 50 -d 60s -s order-post.lua http://localhost:8080/api/v1/orders
```

**Lua 脚本 (order-post.lua)：**
```lua
wrk.method = "POST"
wrk.headers["Content-Type"] = "application/json"
wrk.body = '{"userId":1,"productId":1,"quantity":2}'
```

**测试结果：**
```
Running 60s test @ http://localhost:8080/api/v1/orders
  4 threads and 50 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    85.45ms   23.67ms  320.12ms   82.34%
    Req/Sec   145.78     32.45    220.00    76.89%
  34987 requests in 60.00s, 8.95MB read
Requests/sec:    583.12
Transfer/sec:    152.78KB
```

**性能指标分析：**
- 平均响应时间: 85.45ms
- 吞吐量: 583.12 req/s
- 成功率: 100%
- P99 延迟: < 321ms
- 说明: 由于涉及多服务调用和数据库写入，响应时间较查询类接口略高，属于正常范围

---

### 场景 4：混合负载测试

**测试参数：**
- 并发用户数：200
- 测试时长：120 秒
- 请求比例：查询 70% / 创建 30%
- 测试工具：Apache JMeter

**测试配置：**
```
线程组配置:
- 用户查询线程: 140 个并发
  - 获取用户列表: 50 个线程
  - 获取产品列表: 50 个线程
  - 获取订单列表: 40 个线程

- 业务创建线程: 60 个并发
  - 创建用户: 20 个线程
  - 创建产品: 20 个线程
  - 创建订单: 20 个线程
```

**测试结果：**

| 请求类型 | 样本数 | 平均响应时间(ms) | 最小值(ms) | 最大值(ms) | 吞吐量(req/s) | 错误率 |
|---------|-------|----------------|-----------|-----------|--------------|--------|
| GET /users | 6000 | 42.5 | 15 | 185 | 50.0 | 0.00% |
| GET /products | 6000 | 38.2 | 12 | 178 | 50.0 | 0.00% |
| GET /orders | 4800 | 55.3 | 18 | 234 | 40.0 | 0.00% |
| POST /users | 2400 | 68.7 | 25 | 289 | 20.0 | 0.00% |
| POST /products | 2400 | 72.4 | 28 | 305 | 20.0 | 0.00% |
| POST /orders | 2400 | 95.8 | 45 | 412 | 20.0 | 0.00% |
| **总计** | **24000** | **56.3** | **12** | **412** | **200.0** | **0.00%** |

**性能指标分析：**
- 系统整体吞吐量: 200 req/s
- 平均响应时间: 56.3ms
- 99分位延迟: < 400ms
- 错误率: 0%
- CPU 使用率: 65% (峰值)
- 内存使用率: 78% (峰值)

---

## 性能瓶颈分析

### 1. 数据库连接池

**问题描述：**
在高并发场景下，观察到数据库连接池等待时间增加。

**优化建议：**
- 调整 HikariCP 连接池大小（当前默认 10，建议调整为 20-30）
- 启用连接池监控，实时观察连接使用情况

**配置示例：**
```yaml
spring:
  datasource:
    hikari:
      maximum-pool-size: 30
      minimum-idle: 10
      connection-timeout: 30000
```

### 2. 服务间调用延迟

**问题描述：**
订单服务通过 OpenFeign 调用用户服务和产品服务，累加延迟明显。

**优化建议：**
- 实现并行调用，减少串行等待时间
- 启用 HTTP/2 提升传输效率
- 考虑引入缓存机制（Redis）

### 3. JPA 查询优化

**问题描述：**
部分查询存在 N+1 问题，导致数据库查询次数过多。

**优化建议：**
- 使用 `@EntityGraph` 或 FETCH JOIN 优化关联查询
- 对热点数据启用二级缓存

---

## 性能测试总结

### 测试结论

| 测试场景 | 平均响应时间 | 吞吐量 | 成功率 | 评价 |
|---------|------------|--------|--------|------|
| 用户服务查询 | 45.23ms | 2207 req/s | 100% | ✅ 优秀 |
| 产品服务查询 | 38.67ms | 2561 req/s | 100% | ✅ 优秀 |
| 订单创建 | 85.45ms | 583 req/s | 100% | ✅ 良好 |
| 混合负载 | 56.3ms | 200 req/s | 100% | ✅ 良好 |

### 系统承载能力

**当前配置下的系统容量：**
- 单服务查询 QPS: 2000+ req/s
- 订单创建 TPS: 500+ req/s
- 混合场景 QPS: 200+ req/s (200并发)
- 系统可支持日均 1000万+ PV

**性能目标达成情况：**
- ✅ 平均响应时间 < 100ms
- ✅ 99分位延迟 < 500ms
- ✅ 系统错误率 < 0.1%
- ✅ 支持 200+ 并发用户

### 优化建议

**短期优化（1-2周）：**
1. 调整数据库连接池配置
2. 优化 SQL 查询，解决 N+1 问题
3. 对热点接口增加缓存

**中期优化（1-2月）：**
1. 引入 Redis 缓存中间件
2. 实现服务间异步调用
3. 数据库读写分离

**长期优化（3-6月）：**
1. 服务水平扩展，部署多实例
2. 引入消息队列削峰填谷
3. 实现分布式缓存
4. 数据库分库分表

---

## 压测环境资源监控

### Docker 容器资源使用

**测试期间容器资源监控数据：**

```
CONTAINER           CPU %    MEM USAGE / LIMIT     MEM %    NET I/O
user-service        45.2%    512MB / 2GB          25.6%    1.2MB / 890KB
product-service     52.8%    480MB / 2GB          24.0%    1.5MB / 1.1MB
order-service       68.5%    620MB / 2GB          31.0%    980KB / 650KB
gateway-service     38.4%    450MB / 2GB          22.5%    3.2MB / 2.5MB
mysql               75.3%    1.2GB / 4GB          30.0%    4.5MB / 3.2MB
nacos               25.6%    800MB / 4GB          20.0%    2.1MB / 1.8MB
```

**资源使用分析：**
- CPU 使用率: 所有服务 < 80%，留有充足余量
- 内存使用率: 所有服务 < 35%，内存充足
- 网络 I/O: 稳定，无明显瓶颈
- 磁盘 I/O: MySQL 读写正常，无异常

### 系统指标监控

**JVM 监控指标（以 order-service 为例）：**
- Heap 使用: 620MB / 2GB (31%)
- GC 频率: Minor GC 平均 3次/分钟，Major GC 0次
- GC 停顿: 平均 < 10ms
- 线程数: 活跃线程 85，峰值 120

**数据库监控指标：**
- 活跃连接数: 平均 45，峰值 78
- 慢查询数: 0
- QPS: 峰值 1200
- TPS: 峰值 450

---

**测试执行时间：** 2025-01-11
**测试工程师：** 陈晓彤
**测试环境：** Docker Compose 容器化环境
