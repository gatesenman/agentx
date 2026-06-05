---
name: repo-setup
description: 仓库设置工作流。当需要设置项目环境、安装依赖时使用。
---

# 仓库设置工作流

## 步骤

### 1. 阅读文档
```bash
# 必读文件
cat README.md
cat CONTRIBUTING.md 2>/dev/null
cat SETUP.md 2>/dev/null

# 检查项目类型
ls package.json pyproject.toml Cargo.toml go.mod Gemfile 2>/dev/null
```

### 2. 创建计划
```
创建 todo 列表:
  1. 列出需要安装的工具和版本
  2. 列出需要运行的命令
  3. 发送计划给用户（非阻塞）
```

### 3. 安装依赖
```bash
# Node.js — 检测包管理器
[ -f "pnpm-lock.yaml" ] && pnpm install
[ -f "yarn.lock" ] && yarn install
[ -f "bun.lockb" ] && bun install
[ -f "package-lock.json" ] && npm install

# Python
[ -f "pyproject.toml" ] && pip install -e ".[dev]"
[ -f "requirements.txt" ] && pip install -r requirements.txt

# Rust
[ -f "Cargo.toml" ] && cargo build

# Go
[ -f "go.mod" ] && go mod download
```

### 4. 设置 Pre-commit
```bash
# 检查是否有配置
if [ -f ".pre-commit-config.yaml" ]; then
    pip install pre-commit
    pre-commit install
fi
```

### 5. 运行构建
```bash
npm run build   # 或项目特定构建命令
```

### 6. 运行测试
```bash
npm test        # 或 pytest / cargo test / go test ./...
```

### 7. 验证 Dev Server
```bash
npm run dev     # 或项目特定启动命令
# 检查是否能正常启动
```

## 原则
- 严格按 README 指令（精确版本、精确工具）
- 不修改仓库代码来修设置问题（除非最后手段）
- 被迫偏离 README 时通知用户
- 认证/登录问题立即上报
