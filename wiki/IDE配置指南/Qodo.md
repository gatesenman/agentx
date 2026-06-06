# Qodo 配置指南

## 概述

Qodo（原 Qodo Gen / CodiumAI）是 AI 编程助手，支持 `AGENTS.md` 规则文件和 `.qodo/agents/*.toml` 智能体配置。

---

## 文件清单

| 文件 | 作用 | 必须 |
|------|------|------|
| `AGENTS.md` | 项目规则文件 | 是 |
| `.qodo/agents/code-agent.toml` | 代码智能体配置 | 推荐 |
| `.qodo/agents/review-agent.toml` | 审查智能体配置 | 推荐 |

---

## 安装步骤

```bash
cp agentx/qodo/AGENTS.md /你的项目/
cp -r agentx/qodo/.qodo /你的项目/
```

---

## 规则格式

### AGENTS.md

纯 Markdown，与 Copilot/Codex 格式相同。

### .qodo/agents/*.toml

TOML 格式的智能体配置：

```toml
[agent]
name = "code-agent"
description = "代码智能体 — 编码、审查、调试"

[agent.instructions]
general = """
你是高级软件工程师。遵循以下原则：
- 优先最小化修改范围
- 遵循现有代码风格
...
"""

code_review = """
代码审查时关注：
- 逻辑正确性
- 安全漏洞
- 性能问题
"""

[[agent.commands]]
name = "lint"
command = "npm run lint"

[[agent.commands]]
name = "test"
command = "npm test"

[agent.tools]
terminal = true
file_edit = true
web_search = false
```

### TOML 字段说明

| 字段 | 说明 |
|------|------|
| `agent.name` | 智能体名称 |
| `agent.description` | 智能体描述 |
| `agent.instructions.general` | 通用指令 |
| `agent.instructions.*` | 特定场景指令 |
| `agent.commands` | 可用命令列表 |
| `agent.tools` | 工具权限配置 |

---

## 验证

1. 在 VS Code 中安装 Qodo 扩展
2. 确认文件存在
3. 在 Qodo Chat 中提问验证

---

## 参考

- [Qodo 文档](https://www.qodo.ai/docs)
- [规则系统](../规则系统.md)
