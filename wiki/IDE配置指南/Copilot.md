# GitHub Copilot 配置指南

## 概述

GitHub Copilot 支持两种规则机制：`AGENTS.md`（用于 Copilot Workspace / Codex 模式）和 `.github/copilot-instructions.md`（用于 Copilot Chat）。

---

## 文件清单

| 文件 | 作用 | 必须 |
|------|------|------|
| `AGENTS.md` | Copilot Workspace / Codex 模式规则 | 是 |
| `.github/copilot-instructions.md` | Copilot Chat 指令 | 推荐 |

---

## 安装步骤

```bash
cp agentx/copilot/AGENTS.md /你的项目/
cp -r agentx/copilot/.github /你的项目/
```

---

## 规则格式

两个文件都使用纯 Markdown 格式：

```markdown
# 项目规则

## 核心原则
...
```

### 区别

| 文件 | 加载环境 | 用途 |
|------|---------|------|
| `AGENTS.md` | Copilot Workspace、Codex | 自主编码时的行为规则 |
| `.github/copilot-instructions.md` | VS Code Copilot Chat | Chat 对话时的指令 |

---

## 验证

1. 在 VS Code 中打开 Copilot Chat
2. 提问 "你的工作原则是什么？"
3. 如果回答包含规则内容，说明 `.github/copilot-instructions.md` 已加载
4. 使用 Copilot Workspace 时，`AGENTS.md` 自动加载

---

## 参考

- [Copilot 自定义指令文档](https://docs.github.com/copilot/customizing-copilot)
- [规则系统](../规则系统.md)
