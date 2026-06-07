# AgentX CLI — AI 智能体配置管理工具

一键安装、管理 13 个 IDE 的 AI 智能体规则配置。纯 Bash 实现，零外部依赖。

---

## 快速安装

### 方式一：一键安装（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/gaosichun888/agentx/main/cli/install.sh | bash
```

或使用 wget:

```bash
wget -qO- https://raw.githubusercontent.com/gaosichun888/agentx/main/cli/install.sh | bash
```

### 方式二：手动安装

```bash
# 克隆仓库
git clone https://github.com/gaosichun888/agentx.git ~/.agentx/repo

# 复制到 PATH
mkdir -p ~/.local/bin
cp ~/.agentx/repo/cli/agentx ~/.local/bin/agentx
chmod +x ~/.local/bin/agentx

# 确保 ~/.local/bin 在 PATH 中
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 方式三：直接从仓库运行

```bash
git clone https://github.com/gaosichun888/agentx.git
cd agentx
chmod +x cli/agentx
./cli/agentx help
```

---

## 命令速查

| 命令 | 说明 | 示例 |
|------|------|------|
| `list` | 列出所有支持的 IDE | `agentx list` |
| `install <ide>` | 安装指定 IDE 配置 | `agentx install claude-code` |
| `install <多个ide>` | 同时安装多个 IDE | `agentx install cursor windsurf` |
| `install-all` | 安装所有 13 个 IDE | `agentx install-all` |
| `uninstall <ide>` | 卸载指定 IDE 配置 | `agentx uninstall cursor` |
| `hooks` | 安装 Git Hooks | `agentx hooks` |
| `scan` | 密钥泄露扫描 | `agentx scan` |
| `setup` | 自动检测并安装项目依赖 | `agentx setup` |
| `doctor` | 诊断配置是否正确 | `agentx doctor claude-code` |
| `update` | 更新配置源到最新版本 | `agentx update` |
| `version` | 显示版本号 | `agentx version` |
| `help` | 显示帮助信息 | `agentx help` |

---

## 使用指南

### 1. 查看支持的 IDE

```bash
agentx list
```

输出所有 13 个支持的 IDE，及其核心配置文件格式。

### 2. 安装 IDE 配置

```bash
# 安装到当前目录
agentx install claude-code

# 安装到指定目录
agentx install cursor --target /path/to/project

# 同时安装多个 IDE
agentx install claude-code cursor windsurf

# 安装时同时装 Git Hooks
agentx install claude-code --with-hooks

# 安装时同时复制参考文档
agentx install cursor --with-docs

# 覆盖已存在的文件
agentx install claude-code --force

# 预览模式（不实际执行）
agentx install cursor --dry-run
```

**安装内容：**
- IDE 核心规则文件（如 `CLAUDE.md`、`.cursorrules` 等）
- 工作流文件 (`workflows/`)
- Git Hooks (`hooks/`)
- 脚本工具 (`scripts/`)
- 配置模板 (`templates/`)

### 3. 安装 Git Hooks

```bash
# 安装到当前项目
agentx hooks

# 安装到指定项目
agentx hooks --target /path/to/project

# 覆盖已存在的 hooks
agentx hooks --force
```

**安装的 Hooks：**
- `pre-commit` — 密钥检测、禁止文件检查、大文件检查、lint、typecheck
- `commit-msg` — Conventional Commits 格式验证
- `pre-push` — 分支保护（禁止直推 main/master）

### 4. 密钥泄露扫描

```bash
# 扫描当前目录
agentx scan

# 扫描指定目录
agentx scan --target /path/to/project

# 详细输出
agentx scan --verbose
```

**检测的密钥类型：**
AWS Key、GitHub Token、OpenAI Key、Anthropic Key、私钥、数据库连接串、JWT、Slack Token、Google API Key、通用 API Key、密码赋值

### 5. 项目依赖自动设置

```bash
agentx setup
agentx setup --target /path/to/project
```

**支持的项目类型：**
- Node.js (npm/pnpm/yarn/bun)
- Python (uv/poetry/pipenv/pip)
- Rust (cargo)
- Go (go mod)
- Ruby (bundler)
- PHP (composer)
- Java/Kotlin (Maven/Gradle)
- .NET (dotnet)

自动检测包管理器并安装依赖。

### 6. 配置诊断

```bash
# 检查指定 IDE 配置
agentx doctor claude-code

# 自动检测所有已安装的 IDE
agentx doctor

# 指定目录
agentx doctor cursor --target /path/to/project
```

**检查项：**
- IDE 核心规则文件是否存在
- 共享基础设施文件完整性
- 脚本可执行权限
- Git Hooks 安装状态

### 7. 卸载配置

```bash
# 卸载指定 IDE
agentx uninstall cursor

# 预览模式
agentx uninstall cursor --dry-run
```

### 8. 更新配置源

```bash
agentx update
```

拉取最新版本的 AgentX 配置。

---

## 选项参考

| 选项 | 适用命令 | 说明 |
|------|---------|------|
| `--target <目录>` | install/uninstall/hooks/scan/setup/doctor | 指定目标目录 |
| `--with-docs` | install | 同时安装参考文档到 `.agentx-docs/` |
| `--with-hooks` | install | 同时安装 Git Hooks |
| `--force` | install/hooks | 覆盖已存在的文件 |
| `--dry-run` | install/uninstall/hooks | 预览模式，不实际执行 |
| `--verbose` | scan | 显示所有检查结果（包括通过的） |

---

## 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `AGENTX_SOURCE` | - | 自定义配置源目录（跳过自动检测） |
| `AGENTX_CACHE_DIR` | `~/.agentx` | 配置源缓存目录 |
| `AGENTX_INSTALL_DIR` | `~/.agentx` | 安装目录 |

---

## 典型使用场景

### 场景一：新项目初始化

```bash
mkdir my-project && cd my-project
git init
agentx install claude-code cursor --with-hooks
agentx setup
agentx doctor
```

### 场景二：已有项目添加 AI 智能体

```bash
cd existing-project
agentx install windsurf --force
agentx hooks
```

### 场景三：团队统一配置

```bash
# 在项目根目录安装所有 IDE 配置
agentx install-all --force
git add .
git commit -m "chore: 添加 AgentX AI 智能体配置"
```

### 场景四：安全审计

```bash
agentx scan --target /path/to/project --verbose
```

### 场景五：CI/CD 集成

```yaml
# GitHub Actions
- name: 安装 AgentX
  run: curl -fsSL https://raw.githubusercontent.com/gaosichun888/agentx/main/cli/install.sh | bash

- name: 密钥扫描
  run: agentx scan
```

---

## 系统要求

- **Bash** 4.0+（macOS/Linux/WSL/Git Bash 均可）
- **git**（用于下载配置源）
- 无其他外部依赖

---

## 常见问题

### Q: 安装后找不到 agentx 命令？

确保 `~/.local/bin` 在 PATH 中：

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Q: 如何在 Windows 上使用？

在 Git Bash 或 WSL 中运行即可。PowerShell 不支持。

### Q: 安装后 IDE 没有加载规则？

1. 运行 `agentx doctor <ide>` 检查配置
2. 确认文件在正确的目录层级（项目根目录）
3. 重启 IDE

### Q: 如何卸载 AgentX CLI？

```bash
rm -f ~/.local/bin/agentx
rm -rf ~/.agentx
```
