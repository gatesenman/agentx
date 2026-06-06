# CodeBuddy 配置指南

## 概述

CodeBuddy 是腾讯云推出的 AI 编程助手（VS Code 插件），支持 `CODEBUDDY.md` 全局规则和 `.codebuddy/rules/*.mdc` 上下文规则。

---

## 文件清单

| 文件 | 作用 | 必须 |
|------|------|------|
| `CODEBUDDY.md` | 全局规则文件 | 是 |
| `.codebuddy/rules/code-quality/RULE.mdc` | 代码质量规则 | 推荐 |
| `.codebuddy/rules/git-workflow/RULE.mdc` | Git 工作流规则 | 推荐 |
| `.codebuddy/rules/task-management/RULE.mdc` | 任务管理规则 | 推荐 |

---

## 安装步骤

```bash
cp agentx/codebuddy/CODEBUDDY.md /你的项目/
cp -r agentx/codebuddy/.codebuddy /你的项目/
```

---

## 规则格式（MDC）

`.codebuddy/rules/*/RULE.mdc` 使用 MDC 格式（与 Cursor 类似）：

```markdown
---
description: 代码质量和编辑规则。所有代码修改操作时自动附加。
globs: "**/*.{ts,tsx,js,jsx,py,rs,go,java,rb,cpp,c,cs}"
---

# 代码质量规则
...
```

### Frontmatter 字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `description` | string | 规则描述 |
| `globs` | string | 文件匹配模式 |

**注意**: CodeBuddy 的规则文件放在 `rules/<规则名>/RULE.mdc`，每个规则一个子目录。

---

## 验证

1. 在 VS Code 中安装 CodeBuddy 扩展
2. 打开项目，CodeBuddy 会自动识别规则文件
3. 在 CodeBuddy Chat 中提问验证

---

## 参考

- [CodeBuddy 文档](https://cloud.tencent.com/product/codebuddy)
- [规则系统](../规则系统.md)
