# 修复 NoClassDefFoundError 问题

## 🔍 问题原因

错误信息：
```
java.lang.NoClassDefFoundError: org/springframework/core/convert/ConversionService
```

**根本原因**：
1. ❌ pom.xml 配置的 Java 版本是 25，但系统实际使用的是 Java 21
2. ❌ IDEA 项目配置使用 JDK 25，但系统没有安装
3. ❌ 版本不匹配导致依赖加载失败

## ✅ 已修复的内容

### 1. 更新父 pom.xml
- ✅ 将 Java 版本从 25 改为 21
- ✅ 添加了 maven.compiler.source 和 maven.compiler.target 配置

### 2. 更新所有子模块 pom.xml
- ✅ 为每个服务添加了 spring-boot-starter 依赖
- ✅ 确保依赖顺序正确

### 3. 更新 IDEA 配置
- ✅ 修改 .idea/misc.xml，使用 JDK 21
- ✅ 清理了所有 target 目录

## 🚀 现在请按以下步骤操作

### 步骤 1：配置 IDEA 使用正确的 JDK

1. 打开 **File** → **Project Structure** (Ctrl+Alt+Shift+S)
2. 在 **Project** 标签页：
   - **SDK**: 选择 **21** (Temurin-21.0.4)
   - **Language level**: 选择 **21 - Record patterns, pattern matching for switch**
3. 点击 **OK**

### 步骤 2：重新加载 Maven 项目

1. 点击右侧的 **Maven** 工具窗口
2. 点击刷新按钮 🔄 (**Reload All Maven Projects**)
3. 等待依赖下载完成（观察底部进度条）

### 步骤 3：清理并重新构建

在 Maven 工具窗口中：
1. 展开 **ecommerce-system (root)**
2. 展开 **Lifecycle**
3. 双击 **clean**，等待完成
4. 双击 **compile**，等待完成

或者在终端执行（如果 Maven 可用）：
```bash
mvn clean compile
```

### 步骤 4：重启 IDEA（推荐）

1. **File** → **Invalidate Caches / Restart**
2. 选择 **Invalidate and Restart**
3. 等待 IDEA 重新启动和索引完成

### 步骤 5：启动服务

1. 在右上角运行配置下拉菜单中选择 **"All Services"**
2. 点击绿色运行按钮 ▶️
3. 观察 Run 窗口的启动日志

## 🔍 验证修复

### 检查 Java 版本
在终端执行：
```bash
java -version
```
应该显示：
```
openjdk version "21.0.4"
```

### 检查 Maven 配置
在 Maven 工具窗口中：
1. 右键点击 **ecommerce-system (root)**
2. 选择 **Show Effective POM**
3. 确认 `<java.version>21</java.version>`

### 检查服务启动
启动后应该看到类似的日志：
```
Started UserServiceApplication in X.XXX seconds
```

## ⚠️ 如果问题仍然存在

### 方案 1：手动清理 Maven 缓存
```bash
# Windows
rmdir /s /q %USERPROFILE%\.m2\repository\org\springframework

# 然后在 IDEA 中重新加载 Maven 项目
```

### 方案 2：检查 IDEA 的 Maven 设置
1. **File** → **Settings** → **Build, Execution, Deployment** → **Build Tools** → **Maven**
2. 确认 **Maven home path** 指向有效的 Maven 安装
3. 确认 **User settings file** 和 **Local repository** 路径正确

### 方案 3：使用 IDEA 内置 Maven
1. **File** → **Settings** → **Build, Execution, Deployment** → **Build Tools** → **Maven**
2. **Maven home path**: 选择 **Bundled (Maven 3)**
3. 点击 **OK**
4. 重新加载 Maven 项目

### 方案 4：逐个启动服务（调试模式）
不使用 "All Services"，而是逐个启动：
1. 先启动 **UserServiceApplication**
2. 查看完整的错误堆栈
3. 如果成功，再启动其他服务

## 📝 修改摘要

### 文件变更列表
- ✅ `pom.xml` - Java 版本改为 21
- ✅ `user-service/pom.xml` - 添加 spring-boot-starter
- ✅ `product-service/pom.xml` - 添加 spring-boot-starter
- ✅ `order-service/pom.xml` - 添加 spring-boot-starter
- ✅ `gateway-service/pom.xml` - 添加 spring-boot-starter
- ✅ `.idea/misc.xml` - JDK 配置改为 21
- ✅ 所有 `target/` 目录已清理

## 🎯 预期结果

修复后，所有4个服务应该能够正常启动：
- ✅ user-service 启动在 8081 端口
- ✅ product-service 启动在 8082 端口
- ✅ order-service 启动在 8083 端口
- ✅ gateway-service 启动在 8080 端口

所有服务应该成功注册到 Nacos (http://localhost:8848/nacos)
