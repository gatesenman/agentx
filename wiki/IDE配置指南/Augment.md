# Augment 配置指南

## 概述

Augment Code 是 AI 编程助手，通过 `.augment/rules/*.md` 目录加载项目规则。规则文件需要 YAML frontmatter 指定 `rule_type`。

---

## 文件清单

| 文件 | 作用 | 必须 |
|------|------|------|
| `.augment/rules/01-core-rules.md` | 核心规则 | 是 |
| `.augment/rules/02-git-workflow.md` | Git 工作流规则 | 推荐 |

---

## 安装步骤

```bash
cp -r agentx/augment/.augment /你的项目/
```

---

## 规则格式

必须包含 YAML frontmatter：

```markdown
---
rule_type: always_apply
---

# 核心规则
...
```

### rule_type 选项

| 值 | 说明 |
|----|------|
| `always_apply` | 每次对话都注入 |
| `agent_requested` | AI 自行判断是否需要加载 |
| `manual` | 仅用户手动引用时加载 |

---

## 验证

1. 在 VS Code 中安装 Augment 扩展
2. 确认 `.augment/rules/` 目录存在
3. 与 Augment 对话，规则自动生效

---

## 参考

- [Augment 文档](https://docs.augmentcode.com)
- [规则系统](../规则系统.md)
