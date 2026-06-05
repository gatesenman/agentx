---
name: deployment
description: 部署工作流。当需要部署前端或后端应用时使用。
---

# 部署工作流

## 前端部署

### 静态站点部署
```bash
# 1. 构建
npm run build

# 2. 确认构建输出目录
ls dist/     # 或 build/ 或 out/
ls dist/index.html   # 必须有 index.html

# 3. 部署
# 调用 deploy(command="frontend", dir="项目构建输出目录路径")
```

## 后端部署

### FastAPI 部署
```bash
# 前提:
# - 有 pyproject.toml
# - 有 FastAPI app 实例

# 1. 确认应用可运行
uvicorn main:app --host 0.0.0.0 --port 8000

# 2. 部署（自动生成 Dockerfile 和 fly.toml）
# 调用 deploy(command="backend", dir="项目目录路径")

# 3. 如需持久存储
# 调用 deploy(command="backend", dir="项目目录路径", volume=true)
```

### 查看日志
```
调用 deploy(command="logs")
```

### 暴露本地端口（测试用）
```
调用 deploy(command="expose", port=8000)
# 返回公网 URL，可用于临时测试
```

## 部署检查清单
```
□ 构建成功（无错误）
□ index.html 存在（前端）
□ 应用可启动（后端）
□ 环境变量配置正确
□ 密钥不硬编码
□ 数据库连接正确（如适用）
```

## 部署后验证
```bash
# 前端: 访问部署 URL 确认页面加载
# 后端: 调用健康检查端点
curl https://部署URL/health

# 查看日志确认无错误
# 调用 deploy(command="logs")
```
