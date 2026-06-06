# Windsurf 配置指南

## 概述

Windsurf（原 Codeium Cascade）是 AI IDE，通过 `.windsurfrules` 和 `.windsurf/rules/` 加载项目规则。

---

## 文件清单

| 文件 | 作用 | 必须 |
|------|------|------|
| `.windsurfrules` | 全局规则文件 | 是 |
| `.windsurf/rules/*.md` | 上下文规则文件 | 推荐 |

---

## 安装步骤

```bash
cp agentx/windsurf/.windsurfrules /你的项目/
cp -r agentx/windsurf/.windsurf /你的项目/
```

---

## 规则格式

`.windsurfrules` 使用纯 Markdown，无 frontmatter：

```markdown
# Windsurf 项目规则

## 核心原则
...
```

`.windsurf/rules/*.md` 也是纯 Markdown 格式，按主题分文件。

---

## 验证

1. 打开 Windsurf IDE
2. 在 Cascade 中提问，规则会自动生效
3. 询问 "你的代码质量原则是什么？" 验证是否加载

---

## 参考

- [Windsurf 文档](https://docs.windsurf.com)
- [规则系统](../规则系统.md)
