# 🌐 Nacos 3.1 访问说明

## 📍 正确的访问地址

### Nacos 控制台
**URL**: http://localhost:8848/nacos

**默认账号**：
- 用户名：`nacos`
- 密码：`nacos`

## 🔍 Nacos 3.1 版本说明

Nacos 3.x 版本的架构与 2.x 不同：

### 端口说明
| 端口 | 用途 | 映射状态 |
|------|------|---------|
| 8848 | HTTP API + Console | ✅ 已映射 |
| 9848 | gRPC (服务注册) | ✅ 已映射 |
| 8080 | Console (容器内部) | ❌ 未映射（不需要） |

### 访问方式
- **控制台访问**: http://localhost:8848/nacos
- **API 访问**: http://localhost:8848/nacos/v2/...

## 🎯 如何使用

### 1. 打开浏览器
访问：http://localhost:8848/nacos

### 2. 登录
- 用户名：`nacos`
- 密码：`nacos`

### 3. 查看服务列表
登录后，点击左侧菜单：
- **服务管理** → **服务列表**

你应该看到 4 个服务：
- ✅ user-service
- ✅ product-service
- ✅ order-service
- ✅ gateway-service

### 4. 查看服务详情
点击任意服务名称，可以看到：
- 服务实例列表
- 实例的 IP 和端口
- 健康状态
- 元数据信息

## ⚠️ 常见问题

### 问题 1：页面打不开
**可能原因**：
1. Nacos 容器没有启动
2. 端口被占用
3. 浏览器缓存问题

**解决方案**：
```powershell
# 检查容器状态
docker ps | findstr nacos

# 检查端口
netstat -ano | findstr "8848"

# 重启容器
docker restart nacos

# 清除浏览器缓存或使用无痕模式
```

### 问题 2：登录失败
**可能原因**：
- 用户名或密码错误
- 认证配置问题

**解决方案**：
- 确认使用 `nacos/nacos`
- 检查 docker-compose.yml 中的认证配置

### 问题 3：看不到服务
**可能原因**：
- 服务没有启动
- 服务注册失败
- Nacos 端口配置错误

**解决方案**：
```powershell
# 检查所有服务端口
netstat -ano | findstr "8080 8081 8082 8083"

# 检查服务日志
# 在 IDEA 的 Run 窗口查看启动日志
# 应该看到：[REGISTER-SERVICE] public registering service xxx
```

## 🔧 如果需要映射 8080 端口

如果你想通过 8080 端口访问控制台（可选），可以修改 docker-compose.yml：

```yaml
nacos:
  ports:
    - "8848:8848"
    - "9848:9848"
    - "8080:8080"  # 添加这一行
```

然后重启：
```bash
docker-compose down nacos
docker-compose up -d nacos
```

访问：http://localhost:8080

## 📊 验证服务注册

### 方法 1：通过控制台
1. 访问 http://localhost:8848/nacos
2. 登录
3. 服务管理 → 服务列表
4. 查看 4 个服务是否都在列表中

### 方法 2：通过 API
```powershell
# 获取服务列表
Invoke-WebRequest -Uri "http://localhost:8848/nacos/v2/ns/service/list?pageNo=1&pageSize=10&namespaceId=public" -UseBasicParsing

# 查询特定服务
Invoke-WebRequest -Uri "http://localhost:8848/nacos/v2/ns/instance/list?serviceName=user-service&namespaceId=public" -UseBasicParsing
```

## 🎉 成功标志

当你看到以下内容时，说明一切正常：

1. ✅ 可以访问 http://localhost:8848/nacos
2. ✅ 可以使用 nacos/nacos 登录
3. ✅ 服务列表中显示 4 个服务
4. ✅ 所有服务实例状态为"健康"
5. ✅ 可以点击服务查看详细信息

---

**提示**：如果浏览器显示空白页面，请尝试：
1. 清除浏览器缓存
2. 使用无痕/隐私模式
3. 尝试不同的浏览器（Chrome、Edge、Firefox）
4. 检查浏览器控制台是否有 JavaScript 错误（F12）
