# Git Hooks 自动化

AgentX 提供 3 个 Git Hook 和配套的安装/扫描脚本，自动化代码质量和安全检查。

---

## Hook 总览

| Hook | 触发时机 | 主要功能 |
|------|---------|---------|
| `pre-commit` | `git commit` 前 | 密钥检测、禁止文件、大文件拦截、lint、typecheck |
| `commit-msg` | 编写提交信息后 | Conventional Commits 格式验证 |
| `pre-push` | `git push` 前 | 分支保护、测试运行 |

---

## 安装

### 一键安装

```bash
cd 你的项目
bash hooks/install-hooks.sh
```

### 安装脚本行为

`hooks/install-hooks.sh` 执行以下操作：

1. **检测 Git 仓库** — 确认当前目录是 Git 仓库（存在 `.git/` 目录）
2. **创建 hooks 目录** — 如果 `.git/hooks/` 不存在则创建
3. **备份已有 hooks** — 如果已有同名 hook，重命名为 `*.backup`
4. **复制 hooks** — 从 `hooks/` 目录复制 `pre-commit`、`commit-msg`、`pre-push`
5. **设置权限** — `chmod +x` 确保可执行

### 手动安装

```bash
# 如果不想用安装脚本
cp hooks/pre-commit .git/hooks/pre-commit
cp hooks/commit-msg .git/hooks/commit-msg
cp hooks/pre-push .git/hooks/pre-push
chmod +x .git/hooks/pre-commit .git/hooks/commit-msg .git/hooks/pre-push
```

### 卸载

```bash
rm .git/hooks/pre-commit .git/hooks/commit-msg .git/hooks/pre-push
# 如果有备份，可以恢复
# mv .git/hooks/pre-commit.backup .git/hooks/pre-commit
```

---

## pre-commit Hook 详解

### 5 项检查

#### 1. 密钥检测

扫描暂存文件中的常见密钥模式：

| 密钥类型 | 检测模式 |
|---------|---------|
| AWS Access Key | `AKIA[0-9A-Z]{16}` |
| AWS Secret Key | `aws_secret_access_key` (不区分大小写) |
| OpenAI API Key | `sk-[a-zA-Z0-9]{20,}` |
| GitHub Token | `ghp_[a-zA-Z0-9]{36}`, `github_pat_` |
| 私钥文件 | `-----BEGIN (RSA\|EC\|OPENSSH) PRIVATE KEY-----` |
| 通用密码 | `password\s*=\s*['"][^'"]+['"]` |
| 通用密钥 | `(secret\|token\|api_key)\s*=\s*['"][^'"]+['"]` |

**触发时**: 检测到密钥 → **阻止提交** + 输出提示信息

#### 2. 禁止文件检查

阻止提交以下类型的文件：

| 文件类型 | 匹配模式 |
|---------|---------|
| 环境变量文件 | `.env`, `.env.local`, `.env.production` |
| 证书/密钥 | `*.pem`, `*.key`, `*.p12`, `*.pfx` |
| 凭证文件 | `credentials.json`, `service-account.json` |
| SSH 密钥 | `id_rsa`, `id_ed25519` |

#### 3. 大文件检测

- 阈值: **5MB**（5242880 字节）
- 检查所有暂存的非二进制文件
- 大文件 → **阻止提交** + 提示使用 Git LFS

#### 4. Lint 检查（自动检测）

```bash
# 按优先级检测项目的 lint 工具
if [ -f "package.json" ]; then
    npx eslint --quiet <暂存的JS/TS文件>
elif [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
    ruff check <暂存的Python文件> 2>/dev/null || flake8 <暂存的Python文件>
fi
```

#### 5. 类型检查（自动检测）

```bash
# TypeScript
if [ -f "tsconfig.json" ]; then
    npx tsc --noEmit
fi

# Python
if command -v pyright &>/dev/null; then
    pyright <暂存的Python文件>
elif command -v mypy &>/dev/null; then
    mypy <暂存的Python文件>
fi
```

---

## commit-msg Hook 详解

验证提交信息是否符合 [Conventional Commits](https://www.conventionalcommits.org/) 规范。

### 合法格式

```
<类型>[可选范围]: <描述>

[可选正文]

[可选脚注]
```

### 允许的类型

| 类型 | 说明 |
|------|------|
| `feat` | 新功能 |
| `fix` | Bug 修复 |
| `docs` | 文档变更 |
| `style` | 格式调整（不影响逻辑） |
| `refactor` | 代码重构 |
| `perf` | 性能优化 |
| `test` | 测试相关 |
| `build` | 构建系统变更 |
| `ci` | CI 配置变更 |
| `chore` | 其他杂项 |
| `revert` | 回退提交 |

### 合法示例

```bash
# 通过
git commit -m "feat: 添加用户登录功能"
git commit -m "fix(auth): 修复 token 过期不刷新的问题"
git commit -m "docs: 更新 API 文档"
git commit -m "refactor: 重构数据库连接池"

# 不通过
git commit -m "添加新功能"          # 缺少类型前缀
git commit -m "feat 添加新功能"     # 缺少冒号
git commit -m "Feat: 添加新功能"    # 类型必须小写
```

### 特殊情况

- **合并提交**: 以 `Merge` 开头的消息自动通过
- **Revert**: 以 `Revert` 开头的消息自动通过

---

## pre-push Hook 详解

### 分支保护

```bash
# 阻止直接推送到 main/master
protected_branches=("main" "master")
current_branch=$(git symbolic-ref HEAD | sed 's|refs/heads/||')

if [[ " ${protected_branches[*]} " =~ " $current_branch " ]]; then
    echo "错误: 不允许直接推送到 $current_branch"
    echo "请使用 Pull Request"
    exit 1
fi
```

### 推送前测试（可选）

如果项目有测试脚本，推送前自动运行：

```bash
# 检测并运行测试
if [ -f "package.json" ] && grep -q '"test"' package.json; then
    npm test
fi
```

---

## 配套脚本

### verify-no-secrets.sh — 深度密钥扫描

比 pre-commit hook 更全面的独立扫描脚本：

```bash
bash scripts/verify-no-secrets.sh
```

**扫描 10 类密钥：**

| # | 类型 | 模式 |
|---|------|------|
| 1 | AWS Access Key | `AKIA[0-9A-Z]{16}` |
| 2 | AWS Secret Key | `aws_secret_access_key` |
| 3 | GitHub Token | `ghp_`, `gho_`, `github_pat_` |
| 4 | OpenAI API Key | `sk-[a-zA-Z0-9]{20,}` |
| 5 | 私钥 | `-----BEGIN.*PRIVATE KEY-----` |
| 6 | 数据库连接字符串 | `(mysql\|postgres\|mongodb)://.*:.*@` |
| 7 | JWT Token | `eyJ[a-zA-Z0-9_-]*\.eyJ` |
| 8 | Slack Token | `xox[bprs]-` |
| 9 | Google API Key | `AIza[0-9A-Za-z_-]{35}` |
| 10 | 通用密码赋值 | `(password\|secret\|token)\s*[:=]` |

### setup-project.sh — 项目初始化

```bash
bash scripts/setup-project.sh
```

自动检测项目类型并安装依赖：

| 检测文件 | 执行命令 |
|---------|---------|
| `package.json` | `npm install` |
| `yarn.lock` | `yarn install` |
| `pnpm-lock.yaml` | `pnpm install` |
| `pyproject.toml` | `pip install -e .` 或 `uv sync` |
| `requirements.txt` | `pip install -r requirements.txt` |
| `Gemfile` | `bundle install` |
| `go.mod` | `go mod download` |
| `Cargo.toml` | `cargo fetch` |

---

## 自定义 Hooks

### 添加自定义检查到 pre-commit

编辑 `hooks/pre-commit`，在现有检查后添加：

```bash
# === 自定义检查 ===

# 示例: 检查 TODO 注释
echo "检查 TODO 注释..."
if git diff --cached --name-only | xargs grep -l "TODO" 2>/dev/null; then
    echo "警告: 发现 TODO 注释（不阻止提交）"
fi

# 示例: 运行自定义脚本
if [ -f "scripts/custom-check.sh" ]; then
    bash scripts/custom-check.sh || exit 1
fi
```

### 跳过 Hook（不推荐）

```bash
# 紧急情况下跳过 hook（不推荐）
git commit --no-verify -m "fix: 紧急修复"
```

**注意**: AgentX 规则中明确规定智能体**不得使用 `--no-verify`**，除非用户明确要求。

---

## 故障排查

| 问题 | 原因 | 解决 |
|------|------|------|
| Hook 未触发 | 没有执行权限 | `chmod +x .git/hooks/pre-commit` |
| `bash: hooks/install-hooks.sh: Permission denied` | 脚本没有执行权限 | `chmod +x hooks/install-hooks.sh` |
| Hook 报错找不到命令 | lint/typecheck 工具未安装 | 先安装项目依赖 |
| commit-msg 总是拒绝 | 消息格式不符合规范 | 检查是否有 `feat:` 等前缀 |
| pre-push 拒绝推送 | 推送到保护分支 | 创建 feature 分支再推送 |

---

## 相关文档

- [安全策略](安全策略.md) — 密钥检测的完整策略
- [工作流系统](工作流系统.md) — 在工作流中使用 hooks
- [快速开始](快速开始.md) — hooks 安装步骤
