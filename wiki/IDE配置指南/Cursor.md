# Cursor 配置指南

## 概述

Cursor 是基于 VS Code 的 AI IDE，支持两种规则文件：全局规则（`.cursorrules`）和上下文规则（`.cursor/rules/*.mdc`）。

---

## 文件清单

| 文件 | 作用 | 必须 |
|------|------|------|
| `.cursorrules` | 全局规则（所有对话都注入） | 是 |
| `.cursor/rules/code-quality.mdc` | 代码质量规则 | 推荐 |
| `.cursor/rules/git-workflow.mdc` | Git 工作流规则 | 推荐 |
| `.cursor/rules/task-management.mdc` | 任务管理规则 | 推荐 |
| `.cursor/rules/debugging.mdc` | 调试规则 | 推荐 |
| `.cursor/rules/testing.mdc` | 测试规则 | 推荐 |

---

## 安装步骤

```bash
cp agentx/cursor/.cursorrules /你的项目/
cp -r agentx/cursor/.cursor /你的项目/
```

---

## 规则格式（MDC）

`.cursor/rules/*.mdc` 文件需要 YAML frontmatter：

```markdown
---
description: 代码质量和编辑规则。在编写或修改代码时始终应用。
globs:
alwaysApply: true
---

# 代码质量规则

## 编辑原则
- 优先最小化修改范围
...
```

### Frontmatter 字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `description` | string | 规则描述，Cursor 用来判断是否相关 |
| `globs` | string/空 | 文件匹配模式，空表示不限文件类型 |
| `alwaysApply` | boolean | `true` = 始终注入，`false` = 按需注入 |

### globs 示例

```yaml
# 匹配所有 Python 文件
globs: "**/*.py"

# 匹配多种文件类型
globs: "**/*.{ts,tsx,js,jsx}"

# 匹配特定目录
globs: "src/**/*.ts"

# 所有文件（等同于空）
globs: "**/*"
```

---

## 验证

1. 打开 Cursor IDE
2. 进入 Settings (`Ctrl+,`) → 搜索 "Rules"
3. 查看 Project Rules 下是否显示了 `.cursorrules` 和 `.cursor/rules/` 中的文件
4. 打开 Composer (`Ctrl+I`)，规则会自动注入

---

## 上下文规则 vs 全局规则

| 特性 | `.cursorrules` | `.cursor/rules/*.mdc` |
|------|---------------|---------------------|
| 加载时机 | 每次对话 | 按 `alwaysApply` 和 `globs` 决定 |
| 文件数 | 1 个 | 多个 |
| 适用场景 | 核心规则 | 特定场景/文件类型的规则 |
| 格式 | 纯 Markdown | MDC（带 YAML frontmatter） |

---

## 参考

- [Cursor Rules 文档](https://docs.cursor.com/context/rules)
- [规则系统](../规则系统.md)
