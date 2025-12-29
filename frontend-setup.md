# 🎨 前端快速设置指南

## 📁 第一步：创建前端目录

在项目根目录下创建 `frontend` 文件夹，并将你的文件放进去：

```
ecommerce-system/
└── frontend/          ← 创建这个文件夹
    ├── index.html
    ├── main.js
    └── api.js
```

## 🚀 第二步：选择启动方式

### 方式 1：使用启动脚本（推荐）

双击运行 `start-frontend.bat`，脚本会自动检测并使用可用的 HTTP 服务器。

### 方式 2：手动启动

#### 如果你有 Python：
```bash
cd frontend
python -m http.server 3000
```

#### 如果你有 Node.js：
```bash
cd frontend
npx http-server -p 3000 -c-1
```

#### 如果你有 PHP：
```bash
cd frontend
php -S localhost:3000
```

## 🔧 第三步：配置 API 地址

确保你的 `api.js` 中的 API 地址指向 Gateway：

```javascript
const API_BASE_URL = 'http://localhost:8080';
```

## 🌐 第四步：配置跨域（重要！）

因为前端（3000）和后端（8080）端口不同，需要配置 CORS。

### 创建 CORS 配置文件

在 `gateway-service/src/main/java/com/example/gateway/config/` 目录下创建 `CorsConfig.java`

## 🎯 第五步：访问测试

1. 确保后端服务都在运行
2. 启动前端服务
3. 打开浏览器访问：http://localhost:3000
4. 测试功能是否正常

## ✅ 验证清单

- [ ] 前端文件已放在 `frontend/` 目录
- [ ] 前端服务已启动（端口 3000）
- [ ] 后端服务都在运行（8080-8083）
- [ ] Gateway 已配置 CORS
- [ ] 浏览器可以访问前端页面
- [ ] API 调用正常工作

## 🎊 完成！

现在你的前后端都已经运行起来了！

- 前端：http://localhost:3000
- 后端 Gateway：http://localhost:8080
- Nacos 控制台：http://localhost:8848/nacos
