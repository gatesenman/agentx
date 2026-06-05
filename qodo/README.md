# Qodo 智能体配置

## 安装方法

### AGENTS.md（推荐，简单）
```bash
cp AGENTS.md /你的项目/
```

### Agent TOML 文件（高级）
```bash
mkdir -p ~/.qodo/agents
cp .qodo/agents/code-agent.toml ~/.qodo/agents/
```

## 文件说明

| 文件 | 用途 |
|------|------|
| `AGENTS.md` | 主规则文件，Qodo 自动检测并读取 |
| `.qodo/agents/code-agent.toml` | 高级 Agent 配置（TOML 格式） |
| `workflows/` | 工作流模板 |
| `scripts/` | 可运行脚本 |
| `hooks/` | Git hooks |
| `templates/` | 配置模板 |

## Qodo 规则机制

### AGENTS.md 方式
- Qodo 自动检测项目中的 `AGENTS.md`
- 遵循 agents.md 开放标准
- monorepo 中使用最近的 AGENTS.md
- 最简单的方式，推荐使用

### Agent TOML 文件方式
- 存放在 `~/.qodo/agents/` 目录
- 支持更细粒度的配置:
  - `instructions` — AI 行为指令
  - `tools` — 可用工具列表
  - `execution_strategy` — "act" 或 "plan"
  - `output_schema` — 输出格式定义
  - `commands` — 触发命令名称

### PR Agent 配置 (.pr_agent.toml)
Qodo 还支持代码审查配置:
```toml
[pr_reviewer]
extra_instructions = "使用中文回复"
num_code_suggestions = 3

[pr_description]
generate_ai_title = true
```

## 运行方式

```bash
# 用 Qodo CLI 运行自定义 agent
qodo --agent-file=.qodo/agents/code-agent.toml "修复登录页面的 bug"

# 或通过 IDE 插件使用（自动加载 AGENTS.md）
```
