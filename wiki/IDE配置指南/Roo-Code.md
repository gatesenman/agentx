# Roo Code 配置指南

## 概述

Roo Code 是 AI 编程工具，支持 `.roorules` 全局规则文件和 `.roo/rules/` 上下文规则目录。

---

## 文件清单

| 文件 | 作用 | 必须 |
|------|------|------|
| `.roorules` | 全局规则文件 | 是 |
| `.roo/rules/code-quality.md` | 代码质量规则 | 推荐 |
| `.roo/rules/git-workflow.md` | Git 工作流规则 | 推荐 |

---

## 安装步骤

```bash
cp agentx/roo-code/.roorules /你的项目/
cp -r agentx/roo-code/.roo /你的项目/
```

---

## 规则格式

纯 Markdown 格式，无 frontmatter：

```markdown
# Roo Code 项目规则

## 核心原则
...
```

`.roorules` 是全局入口，`.roo/rules/*.md` 按主题分文件。

---

## 验证

1. 在 IDE 中安装 Roo Code
2. 确认 `.roorules` 和 `.roo/rules/` 存在
3. 与 Roo Code 对话验证规则加载

---

## 参考

- [Roo Code 文档](https://docs.roocode.com)
- [规则系统](../规则系统.md)
