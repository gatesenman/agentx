# Cline 配置指南

## 概述

Cline 是 VS Code 的 AI 编程插件，通过 `.clinerules/` 目录下的 Markdown 文件加载项目规则。

---

## 文件清单

| 文件 | 作用 | 必须 |
|------|------|------|
| `.clinerules/core-rules.md` | 核心工作规则 | 是 |
| `.clinerules/code-quality.md` | 代码质量规则 | 推荐 |
| `.clinerules/git-workflow.md` | Git 工作流规则 | 推荐 |
| `.clinerules/task-management.md` | 任务管理规则 | 推荐 |

---

## 安装步骤

```bash
cp -r agentx/cline/.clinerules /你的项目/
```

---

## 规则格式

纯 Markdown，无 frontmatter，按模块分文件：

```markdown
# 核心工作规则

## 身份
你是高级软件工程师...

## 核心原则
...
```

Cline 会自动读取 `.clinerules/` 目录下的所有 `.md` 文件并合并为上下文。

---

## 验证

1. 在 VS Code 中安装 Cline 扩展
2. 打开含有 `.clinerules/` 目录的项目
3. 与 Cline 对话，规则自动生效

---

## 参考

- [Cline 文档](https://github.com/cline/cline)
- [规则系统](../规则系统.md)
