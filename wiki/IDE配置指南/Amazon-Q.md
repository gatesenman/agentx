# Amazon Q Developer 配置指南

## 概述

Amazon Q Developer 是 AWS 推出的 AI 编程助手，通过 `.amazonq/rules/*.md` 目录加载项目规则。

---

## 文件清单

| 文件 | 作用 | 必须 |
|------|------|------|
| `.amazonq/rules/01-core-rules.md` | 核心规则 | 是 |
| `.amazonq/rules/02-git-workflow.md` | Git 工作流规则 | 推荐 |

---

## 安装步骤

```bash
cp -r agentx/amazon-q/.amazonq /你的项目/
```

---

## 规则格式

纯 Markdown，无 frontmatter，按模块编号：

```markdown
# 核心工作规则

## 身份
你是高级软件工程师...

## 核心原则
...
```

文件按编号排序加载（`01-` 先于 `02-`）。

---

## 验证

1. 在 VS Code 中安装 Amazon Q 扩展
2. 确认 `.amazonq/rules/` 目录存在
3. 在 Amazon Q Chat 中提问验证

---

## 参考

- [Amazon Q 文档](https://docs.aws.amazon.com/amazonq)
- [规则系统](../规则系统.md)
