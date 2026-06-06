# Devin 配置指南

## 概述

Devin 是 Cognition AI 的自主 AI 软件工程师平台。通过仓库中的 `.devin/skills/` 目录加载技能文件，技能在会话中按需激活。

---

## 文件清单

| 文件 | 作用 | 必须 |
|------|------|------|
| `.devin/skills/pr-workflow/SKILL.md` | PR 创建工作流 | 推荐 |
| `.devin/skills/repo-setup/SKILL.md` | 仓库设置工作流 | 推荐 |
| `.devin/skills/testing/SKILL.md` | 测试与录屏工作流 | 推荐 |
| `.devin/skills/debugging/SKILL.md` | 调试工作流 | 推荐 |
| `.devin/skills/code-review/SKILL.md` | 代码审查工作流 | 推荐 |
| `.devin/skills/deployment/SKILL.md` | 部署工作流 | 推荐 |
| `.devin/skills/child-sessions/SKILL.md` | 子会话管理 | 推荐 |
| `.devin/skills/data-analysis/SKILL.md` | 数据分析工作流 | 推荐 |

---

## 安装步骤

```bash
# 复制到你的项目
cp -r agentx/devin/.devin /你的项目/

# 必须推送到远程仓库（Devin 从远程读取）
cd /你的项目
git add .devin/
git commit -m "feat: 添加 Devin 技能配置"
git push
```

**重要**: Devin 从远程仓库读取技能文件，本地文件无效，必须 push 到远程。

---

## 技能文件格式

每个技能文件都需要 YAML frontmatter：

```markdown
---
name: pr-workflow
description: PR 创建工作流。当需要创建 Pull Request 时使用。
---

# PR 创建工作流

## 步骤

### 第一步: 确认修改完成
- 运行 lint 和 typecheck
- 确保所有测试通过
...
```

### Frontmatter 必填字段

| 字段 | 说明 |
|------|------|
| `name` | 技能唯一标识（小写、连字符分隔） |
| `description` | 技能描述（Devin 用于判断何时激活） |

### 目录结构规范

```
.devin/skills/
├── <技能名>/
│   └── SKILL.md    # 每个技能一个目录，文件名固定为 SKILL.md
├── pr-workflow/
│   └── SKILL.md
└── testing/
    └── SKILL.md
```

---

## 技能激活机制

1. 用户创建 Devin 会话时，平台扫描仓库 `.devin/skills/` 目录
2. Devin 根据任务类型匹配 `description` 字段
3. 匹配的技能被激活，成为首要指令来源
4. 也可以用户手动通过 `skill invoke` 激活

### 激活后的行为规则

- 技能文件成为首要指令来源
- 必须按步骤顺序执行
- 不能跳步或替换步骤
- 步骤失败时排查修复，不跳过

---

## 与其他 Devin 机制的关系

| 机制 | 说明 | 与技能的关系 |
|------|------|------------|
| Knowledge | 跨会话知识库 | 提供上下文，不指导步骤 |
| Playbooks | 组织级工作流模板 | 类似技能但平台级管理 |
| Blueprints | 环境配置 | 设置运行环境 |
| Automations | 事件驱动自动化 | 触发会话 |

---

## 验证

1. 将 `.devin/skills/` 推送到远程仓库
2. 在 Devin 平台创建会话，选择对应仓库
3. 在会话中输入 `skill list` 查看可用技能
4. 或直接给任务，Devin 会自动匹配并激活相关技能

---

## 参考

- [Devin 文档](https://docs.devin.ai)
- [规则系统](../规则系统.md)
