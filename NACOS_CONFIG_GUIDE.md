# Nacos 配置中心使用说明

## 阶段4：配置中心实现

本项目已为以下服务集成 Nacos 配置中心：
- user-service
- product-service
- order-service

## 配置说明

### 1. 访问 Nacos 控制台

启动服务后，访问 Nacos 管理界面：
```
http://localhost:8848/nacos
默认账号：nacos
默认密码：nacos
```

### 2. 创建配置

#### 2.1 user-service 配置

在 Nacos 控制台创建配置：

- **Data ID**: `user-service-dev.yaml`
- **Group**: `DEFAULT_GROUP`
- **配置格式**: `YAML`
- **配置内容**:

```yaml
# 用户服务业务配置
business:
  max-page-size: 100          # 最大分页大小
  feature-enabled: true       # 是否启用新特性
```

#### 2.2 product-service 配置

- **Data ID**: `product-service-dev.yaml`
- **Group**: `DEFAULT_GROUP`
- **配置格式**: `YAML`
- **配置内容**:

```yaml
# 产品服务业务配置
business:
  max-page-size: 50           # 最大分页大小
  discount-enabled: true      # 是否启用折扣功能
```

#### 2.3 order-service 配置

- **Data ID**: `order-service-dev.yaml`
- **Group**: `DEFAULT_GROUP`
- **配置格式**: `YAML`
- **配置内容**:

```yaml
# 订单服务业务配置
business:
  max-page-size: 20           # 最大分页大小
  auto-confirm-enabled: false # 是否自动确认订单
```

### 3. 测试配置中心功能

#### 3.1 查看当前配置

```bash
# 查看 user-service 配置
curl http://localhost:8081/config

# 查看 product-service 配置
curl http://localhost:8082/config

# 查看 order-service 配置
curl http://localhost:8083/config
```

#### 3.2 测试动态刷新

1. 在 Nacos 控制台修改配置（例如将 `max-page-size` 改为 200）
2. 点击"发布"按钮
3. 等待几秒后，再次调用配置接口查看
4. 配置会自动刷新，无需重启服务

示例：
```bash
# 修改前
curl http://localhost:8081/config
# {"maxPageSize":100,"featureEnabled":true,"timestamp":1735000000000}

# 在 Nacos 中修改 max-page-size 为 200 并发布

# 修改后（无需重启）
curl http://localhost:8081/config
# {"maxPageSize":200,"featureEnabled":true,"timestamp":1735000001000}
```

### 4. 配置中心架构说明

```
┌─────────────────────────────────────────────────────┐
│                   Nacos Server                       │
│  ┌──────────────────────────────────────────────┐  │
│  │  user-service-dev.yaml                        │  │
│  │  product-service-dev.yaml                     │  │
│  │  order-service-dev.yaml                       │  │
│  └──────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────┘
         ▲              ▲              ▲
         │              │              │
    配置拉取        配置拉取        配置拉取
    动态刷新        动态刷新        动态刷新
         │              │              │
    ┌─────────┐   ┌──────────┐   ┌─────────┐
    │  user   │   │ product  │   │  order  │
    │ service │   │ service  │   │ service │
    └─────────┘   └──────────┘   └─────────┘
```

## 实现要点

### 关键依赖

```xml
<!-- Nacos Config -->
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-nacos-config</artifactId>
</dependency>

<!-- Spring Cloud Bootstrap -->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-bootstrap</artifactId>
</dependency>
```

### 配置类注解

```java
@Component
@RefreshScope  // 支持配置动态刷新
public class BusinessConfig {
    @Value("${business.max-page-size:100}")
    private Integer maxPageSize;
    // ...
}
```

### Bootstrap 配置

```yaml
spring:
  application:
    name: user-service
  cloud:
    nacos:
      config:
        server-addr: nacos:8848
        file-extension: yaml
        refresh-enabled: true  # 启用动态刷新
  profiles:
    active: dev
```

## 配置命名规则

Nacos 会根据以下规则查找配置：
```
${spring.application.name}-${spring.profiles.active}.${file-extension}
```

例如：
- user-service + dev 环境 → `user-service-dev.yaml`
- product-service + prod 环境 → `product-service-prod.yaml`

## 验证清单

- [ ] Nacos 控制台可以正常访问（http://localhost:8848/nacos）
- [ ] 所有服务的配置文件已在 Nacos 中创建
- [ ] 各服务的 /config 接口能正常返回配置
- [ ] 在 Nacos 中修改配置后，服务能自动刷新

## 常见问题

### Q1: 服务启动报错 "Could not resolve placeholder"
**A**: 检查 Nacos 中是否已创建对应的配置文件，Data ID 命名是否正确。

### Q2: 修改配置后没有自动刷新
**A**: 确认配置类是否添加了 `@RefreshScope` 注解，且 `refresh-enabled: true`。

### Q3: 配置文件找不到
**A**: 检查 bootstrap.yml 中的服务名称、环境、file-extension 是否配置正确。

## Docker Compose 预期输出

执行 `docker-compose ps` 应该看到：

```
NAME                STATUS              PORTS
mysql               Up (healthy)        0.0.0.0:3307->3306/tcp
nacos               Up                  0.0.0.0:8848->8848/tcp
user-service        Up                  0.0.0.0:8081->8081/tcp
product-service     Up                  0.0.0.0:8082->8082/tcp
order-service       Up                  0.0.0.0:8083->8083/tcp
gateway-service     Up                  0.0.0.0:8080->8080/tcp
frontend            Up                  0.0.0.0:8088->80/tcp
```

所有服务状态应为 `Up`，Nacos 服务正常运行。
