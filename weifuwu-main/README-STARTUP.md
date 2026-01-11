# 微服务项目启动指南

## 项目结构
本项目包含4个微服务：
- **user-service** (端口: 8081) - 用户服务
- **product-service** (端口: 8082) - 产品服务  
- **order-service** (端口: 8083) - 订单服务
- **gateway-service** (端口: 8080) - API网关

## 启动步骤

### 方式一：使用 IntelliJ IDEA（推荐）

#### 1. 启动基础设施
确保 Docker Desktop 正在运行，然后执行：
```bash
docker-compose up -d
```

或者双击运行 `start-infrastructure.bat`

#### 2. 初始化数据库
双击运行 `init-databases.bat` 或手动执行：
```bash
mysql -h localhost -P 3306 -u root -p123456 < init-db\create-db.sql
```

#### 3. 启动所有微服务
在 IntelliJ IDEA 中：
- 找到右上角的运行配置下拉菜单
- 选择 **"All Services"** 配置
- 点击运行按钮（绿色三角形）

这将同时启动所有4个微服务。

或者单独启动每个服务：
- UserServiceApplication
- ProductServiceApplication  
- OrderServiceApplication
- GatewayApplication

### 方式二：使用命令行

#### 1. 启动基础设施
```bash
docker-compose up -d
```

#### 2. 初始化数据库
```bash
mysql -h localhost -P 3306 -u root -p123456 < init-db\create-db.sql
```

#### 3. 编译项目
```bash
mvn clean install -DskipTests
```

#### 4. 启动各个服务
```bash
# 启动用户服务
cd user-service
mvn spring-boot:run

# 启动产品服务（新终端）
cd product-service
mvn spring-boot:run

# 启动订单服务（新终端）
cd order-service
mvn spring-boot:run

# 启动网关服务（新终端）
cd gateway-service
mvn spring-boot:run
```

## 验证服务状态

### 检查 Nacos 注册中心
访问: http://localhost:8848/nacos
- 用户名: nacos
- 密码: nacos

在服务列表中应该能看到所有4个服务已注册。

### 测试 API 网关
通过网关访问各个服务：
- 用户服务: http://localhost:8080/api/v1/users
- 产品服务: http://localhost:8080/api/v1/products
- 订单服务: http://localhost:8080/api/v1/orders

### 直接访问各个服务
- 用户服务: http://localhost:8081
- 产品服务: http://localhost:8082
- 订单服务: http://localhost:8083
- 网关服务: http://localhost:8080

## 停止服务

### 停止微服务
在 IntelliJ IDEA 中点击停止按钮，或在命令行中按 Ctrl+C

### 停止基础设施
```bash
docker-compose down
```

## 常见问题

### 1. Docker 无法启动
确保 Docker Desktop 已安装并正在运行。

### 2. 端口被占用
检查端口 3306, 8080, 8081, 8082, 8083, 8848 是否被其他程序占用。

### 3. 服务无法注册到 Nacos
- 确保 Nacos 已启动（docker ps 查看）
- 检查 application.yml 中的 Nacos 地址配置

### 4. 数据库连接失败
- 确保 MySQL 已启动
- 确认数据库已初始化（运行 init-databases.bat）
- 检查用户名密码是否正确（root/123456）
