# OpenAI Codex 配置指南

## 概述

OpenAI Codex CLI 是 OpenAI 的终端 AI 编程工具，通过 `AGENTS.md` 加载项目规则。

---

## 文件清单

| 文件 | 作用 | 必须 |
|------|------|------|
| `AGENTS.md` | 项目规则文件 | 是 |

---

## 安装步骤

```bash
cp agentx/codex/AGENTS.md /你的项目/
```

或安装到用户级别：

```bash
cp agentx/codex/AGENTS.md ~/.codex/
```

---

## 规则格式

纯 Markdown，无 frontmatter：

```markdown
# 项目规则

## 核心原则
...
```

---

## 验证

```bash
# 在项目目录运行 Codex
cd /你的项目
codex

# 提问验证
# "你的 Git 规则是什么？"
```

---

## 参考

- [Codex CLI 文档](https://github.com/openai/codex)
- [规则系统](../规则系统.md)
