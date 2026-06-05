# 完整使用教程

> 从零开始配置你的 AI 编程助手，让它按照专业规则工作。

---

## 目录

1. [概述：什么是智能体规则](#概述)
2. [Claude Code 完整教程](#claude-code)
3. [Cursor 完整教程](#cursor)
4. [Windsurf 完整教程](#windsurf)
5. [GitHub Copilot 完整教程](#github-copilot)
6. [OpenAI Codex CLI 完整教程](#openai-codex-cli)
7. [Cline 完整教程](#cline)
8. [CodeBuddy 完整教程](#codebuddy)
9. [Augment Code 完整教程](#augment-code)
10. [Aider 完整教程](#aider)
11. [Roo Code 完整教程](#roo-code)
12. [Amazon Q Developer 完整教程](#amazon-q-developer)
13. [Qodo 完整教程](#qodo)
14. [Devin 完整教程](#devin)

---

## 概述

### 什么是智能体规则？

智能体规则是一组指令文件，告诉 AI 编程助手：
- **如何工作** — 代码风格、编辑原则、质量标准
- **什么能做** — 允许的操作范围
- **什么不能做** — 禁止的操作（如 force push 到 main）
- **遇到问题怎么办** — 错误处理、冲突解决、上报流程

### 为什么需要它？

没有规则的 AI 助手会：
- 随意修改不相关的文件
- 写过多注释和不必要的代码
- 不遵循项目的代码风格
- 可能提交敏感文件
- 遇到问题时放弃或给出错误方案

有了规则后：
- AI 行为可预测、可控
- 代码质量一致
- 安全底线有保障
- 工作流程标准化

### 安装的通用步骤

```bash
# 1. 克隆本仓库
git clone https://github.com/gaosichun888/agentx.git

# 2. 进入你要配置的 IDE 目录
cd agentx/<ide-name>

# 3. 复制核心文件到你的项目
cp <核心文件> /path/to/your-project/

# 4. (可选) 复制辅助文件
cp -r workflows/ scripts/ hooks/ templates/ /path/to/your-project/.agent-docs/
```

---

## Claude Code

### 环境要求
- 安装 Claude Code: `npm install -g @anthropic-ai/claude-code`
- 有效的 Anthropic API key 或 Claude Pro/Team 订阅

### 安装步骤

```bash
# 核心文件（必须）
cp agentx/claude-code/CLAUDE.md /你的项目/

# 个人覆盖文件（可选，不提交到 git）
cp agentx/claude-code/CLAUDE.local.md /你的项目/
echo "CLAUDE.local.md" >> /你的项目/.gitignore
```

### 文件作用

| 文件 | 作用 | 是否提交 git |
|------|------|-------------|
| `CLAUDE.md` | 团队共享规则，Claude Code 自动读取 | 是 |
| `CLAUDE.local.md` | 个人偏好覆盖（语言、风格） | 否（加入 .gitignore） |

### 验证是否生效

```bash
cd /你的项目
claude  # 启动 Claude Code
# 输入: "你的工作规则是什么？"
# Claude 应该能描述出 CLAUDE.md 中的核心原则
```

### 使用场景

**场景 1：修复 Bug**
```
你: 登录页面在输入错误密码时没有显示错误提示
Claude: (会按照规则: 先搜索代码→定位问题→最小化修改→运行 lint→创建 PR)
```

**场景 2：添加新功能**
```
你: 给用户设置页面添加暗色模式切换
Claude: (会按照规则: 先研究现有组件→理解代码风格→实现→测试→PR)
```

**场景 3：代码审查**
```
你: review 一下 PR #42
Claude: (会按照规则: 阅读所有评论→逐条处理→新提交修复→不 amend)
```

### 进阶配置

在 `CLAUDE.local.md` 中添加个人偏好:
```markdown
# 个人偏好
- 我偏好 TypeScript 严格模式
- 项目用 pnpm 而非 npm
- 测试用 Vitest 而非 Jest
- 回复用中文
```

---

## Cursor

### 环境要求
- 安装 Cursor IDE (https://cursor.com)
- 有效的 Cursor Pro 订阅（或免费额度）

### 安装步骤

```bash
# 核心规则文件（必须）
cp agentx/cursor/.cursorrules /你的项目/

# 上下文规则（推荐，更灵活）
cp -r agentx/cursor/.cursor /你的项目/
```

### 文件作用

| 文件 | 作用 | 加载条件 |
|------|------|---------|
| `.cursorrules` | 全局规则，每次对话都加载 | 始终 |
| `.cursor/rules/code-quality.mdc` | 代码质量规则 | `alwaysApply: true` |
| `.cursor/rules/git-workflow.mdc` | Git 规则 | 需要时加载 |
| `.cursor/rules/debugging.mdc` | 调试规则 | 需要时加载 |
| `.cursor/rules/repo-setup.mdc` | 仓库设置规则 | 需要时加载 |
| `.cursor/rules/testing.mdc` | 测试规则 | 需要时加载 |

### .mdc 文件格式说明

```markdown
---
description: 规则描述（Agent 用来判断是否需要加载）
alwaysApply: false
---

# 规则内容（Markdown 格式）
...
```

- `alwaysApply: true` — 每次对话自动加载
- `alwaysApply: false` — Cursor 根据 description 判断是否需要

### 验证是否生效

1. 打开 Cursor IDE
2. 打开你的项目
3. 在 Chat 或 Composer 中输入: "你的规则是什么？"
4. Cursor 应该能描述规则内容

### 使用场景

**在 Composer 中（多文件编辑）:**
- Cursor 会自动遵循 `.cursorrules` 中的代码风格
- 不会生成过多注释
- 会检查 import 是否正确

**在 Chat 中（问答/方案设计）:**
- 回复简洁
- 会先搜索代码再回答
- 建议最小化修改

---

## Windsurf

### 环境要求
- 安装 Windsurf IDE (https://windsurf.com)
- 有效订阅

### 安装步骤

```bash
# 核心文件
cp agentx/windsurf/.windsurfrules /你的项目/

# 上下文规则
cp -r agentx/windsurf/.windsurf /你的项目/
```

### 文件作用

| 文件 | 作用 | 触发条件 |
|------|------|---------|
| `.windsurfrules` | 全局规则 | 始终加载 |
| `.windsurf/rules/code-quality.md` | 代码质量 | `trigger: always` |
| `.windsurf/rules/git-workflow.md` | Git 规则 | `trigger: manual` |
| `.windsurf/rules/debugging.md` | 调试规则 | `trigger: manual` |

### Windsurf 规则 frontmatter

```markdown
---
trigger: always | manual | glob_pattern
description: 规则描述
---
```

- `trigger: always` — 每次对话加载
- `trigger: manual` — 用 @ 提及时加载
- `trigger: "src/**/*.ts"` — 编辑匹配文件时加载

---

## GitHub Copilot

### 环境要求
- VS Code / JetBrains IDE + GitHub Copilot 插件
- GitHub Copilot 订阅

### 安装步骤

```bash
# 核心文件
cp agentx/copilot/AGENTS.md /你的项目/

# Copilot Chat 指令
cp -r agentx/copilot/.github /你的项目/
```

### 文件作用

| 文件 | 作用 |
|------|------|
| `AGENTS.md` | Copilot Workspace / Codex 自动读取 |
| `.github/copilot-instructions.md` | Copilot Chat 上下文指令 |

### 验证

在 VS Code 中打开 Copilot Chat，输入 `@workspace 你的规则是什么？`

---

## OpenAI Codex CLI

### 环境要求
- 安装 Codex CLI: `npm install -g @openai/codex`
- OpenAI API key

### 安装步骤

```bash
# 项目级
cp agentx/codex/AGENTS.md /你的项目/

# 或全局级
mkdir -p ~/.codex
cp agentx/codex/AGENTS.md ~/.codex/
```

### 优先级链

```
~/.codex/AGENTS.override.md    ← 临时覆盖（最高优先级）
~/.codex/AGENTS.md             ← 个人全局
项目根/AGENTS.md               ← 团队共享
子目录/AGENTS.md               ← 按路径深度叠加
```

### 使用

```bash
cd /你的项目
codex "修复登录页面的验证逻辑"
# Codex 会读取 AGENTS.md 后按规则工作
```

---

## Cline

### 环境要求
- VS Code + Cline 扩展 (marketplace 搜索 "Cline")
- API key (Anthropic / OpenAI / 其他)

### 安装步骤

```bash
# 目录格式（推荐）
cp -r agentx/cline/.clinerules /你的项目/
```

### 规则文件说明

```
.clinerules/
├── 01-core-rules.md        # 核心原则
├── 02-code-quality.md      # 代码质量
├── 03-git-workflow.md      # Git 规则
└── 04-task-management.md   # 任务管理
```

### 条件规则（高级）

可以给特定文件路径设置不同规则:

```yaml
---
paths:
  - "src/api/**"
---
# 以下规则仅在编辑 API 文件时生效
- 所有 API 端点必须有错误处理
- 返回标准格式 { data, error, status }
```

### 全局规则

Cline 全局规则目录（所有项目生效）:
- macOS: `~/Library/Application Support/Code/User/globalStorage/saoudrizwan.claude-dev/rules/`
- Linux: `~/.config/Code/User/globalStorage/saoudrizwan.claude-dev/rules/`

---

## CodeBuddy

### 环境要求
- VS Code / JetBrains IDE + CodeBuddy 插件
- 腾讯云账号

### 安装步骤

```bash
# 简单方式
cp agentx/codebuddy/CODEBUDDY.md /你的项目/

# 完整方式（结构化规则）
cp agentx/codebuddy/CODEBUDDY.md /你的项目/
cp -r agentx/codebuddy/.codebuddy /你的项目/
```

### 规则层级

| 层级 | 位置 | 适用范围 |
|------|------|---------|
| 项目规则 | `.codebuddy/rules/` | 当前项目 |
| 用户规则 | `~/.codebuddy/rules/` | 所有项目 |
| CODEBUDDY.md | 项目根目录 | 当前项目 |

---

## Augment Code

### 环境要求
- VS Code + Augment 扩展
- Augment 账号

### 安装步骤

```bash
# 工作区规则
cp -r agentx/augment/.augment /你的项目/

# 或用户全局
cp agentx/augment/.augment/rules/*.md ~/.augment/rules/
```

### 规则类型

| frontmatter | 行为 | 适用 |
|-------------|------|------|
| `rule_type: always_apply` | 每次对话加载 | 核心规则 |
| `rule_type: agent_requested` | Agent 自动判断 | 场景规则 |
| `rule_type: manual` | @ 手动附加 | 偶尔需要 |

---

## Aider

### 环境要求
- Python 3.9+
- 安装 Aider: `pip install aider-chat`
- API key (Anthropic / OpenAI)

### 安装步骤

```bash
cp agentx/aider/.aider.conf.yml /你的项目/
cp agentx/aider/CONVENTIONS.md /你的项目/
cp agentx/aider/.aiderignore /你的项目/
```

### 配置说明

**`.aider.conf.yml`** — 控制运行时行为:
```yaml
model: claude-sonnet-4-20250514   # 使用的模型
dark-mode: true              # 暗色输出
auto-commits: true           # 自动提交
read:                        # 自动加载的只读文件
  - CONVENTIONS.md
auto-lint: true              # 自动 lint
```

**`CONVENTIONS.md`** — 代码约定（Aider 只读不改）

**`.aiderignore`** — 不让 Aider 编辑的文件

### 使用

```bash
cd /你的项目
aider
# 进入交互模式后直接描述任务
> 修复用户注册时邮箱验证不生效的问题
```

---

## Roo Code

### 环境要求
- VS Code + Roo Code 扩展
- API key

### 安装步骤

```bash
# 目录格式（推荐）
cp -r agentx/roo-code/.roo /你的项目/

# 或单文件格式
cp agentx/roo-code/.roorules /你的项目/
```

### 模式特定规则

Roo Code 有多种工作模式，可以为每种模式设不同规则:
```
.roo/
├── rules/            # 所有模式通用
├── rules-code/       # Code 模式专用
├── rules-architect/  # Architect 模式专用
├── rules-docs/       # Docs 模式专用
└── rules-ask/        # Ask 模式专用
```

---

## Amazon Q Developer

### 环境要求
- VS Code / JetBrains IDE + Amazon Q 插件
- AWS 账号 + AmazonQDeveloperAccess 权限

### 安装步骤

```bash
cp -r agentx/amazon-q/.amazonq /你的项目/
```

### 规则格式

- 放在 `.amazonq/rules/` 目录
- Markdown 格式
- 自动作为上下文加载到所有对话

---

## Qodo

### 环境要求
- VS Code / JetBrains IDE + Qodo 插件
- 或 Qodo CLI: `npm install -g @qodo/cli`

### 安装步骤

```bash
# 简单方式（大部分场景够用）
cp agentx/qodo/AGENTS.md /你的项目/

# 高级方式（TOML Agent 配置）
mkdir -p ~/.qodo/agents
cp agentx/qodo/.qodo/agents/code-agent.toml ~/.qodo/agents/
```

### CLI 使用

```bash
# 用自定义 agent
qodo --agent-file=.qodo/agents/code-agent.toml "你的任务描述"
```

---

## Devin

### 环境要求
- Devin 平台账号 (https://devin.ai)
- 仓库已连接到 Devin

### 安装步骤

```bash
# 复制技能文件到你的仓库
cp -r agentx/devin/.devin /你的仓库/
git add .devin/
git commit -m "chore: 添加 Devin 技能配置"
git push
```

### 技能文件说明

```
.devin/skills/
├── pr-workflow/SKILL.md      # PR 创建流程
├── repo-setup/SKILL.md       # 仓库设置
├── testing/SKILL.md          # 测试流程
├── debugging/SKILL.md        # 调试流程
├── code-review/SKILL.md      # 代码审查
├── deployment/SKILL.md       # 部署
├── child-sessions/SKILL.md   # 子会话管理
└── data-analysis/SKILL.md    # 数据分析
```

### Devin 额外配置

除了 Skills，Devin 还支持:
- **Knowledge** — 知识库笔记（通过 Devin 设置界面创建）
- **Playbooks** — 可复用的多步骤流程
- **Blueprints** — 环境配置（安装依赖、设置工具）
- **Automations** — 事件驱动的自动化（PR 审查、Issue 分类等）

---

## 下一步

- [自定义指南](./CUSTOMIZATION.md) — 如何修改规则以适应你的项目
- [工作流详解](./WORKFLOWS-GUIDE.md) — 4 个工作流的详细使用说明
- [迁移指南](./MIGRATION.md) — 从一个 IDE 切换到另一个
- [最佳实践](./BEST-PRACTICES.md) — 高效使用 AI 编程助手的建议
- [常见问题](./FAQ.md) — 遇到问题时查看
