# Devin 知识系统

## 概述

知识笔记是 Devin 在当前任务相关时自动检索的上下文信息。它们捕获会话中可泛化的经验。

---

## 知识笔记结构

```yaml
id: "note-<uuid>"
name: "简短描述性名称"
trigger: "何时检索此知识"
content: |
  实际知识内容。
  应具体且可操作。
author: "user" | "system"
scope: "何时呈现的描述"
```

---

## 知识类型

### 1. 仓库特定知识
```yaml
name: "React 应用测试配置"
trigger: "当在前端仓库工作时"
content: |
  - 单元测试用 vitest
  - e2e 测试用 playwright
  - 测试账号: test@example.com / password123
  - 运行 `npm run test:e2e` 执行完整套件
  - e2e 测试需要 dev server 运行中
```

### 2. 工作流知识
```yaml
name: "PR 约定"
trigger: "当创建 pull request 时"
content: |
  - PR 标题始终包含 JIRA 单号
  - 使用 conventional commits (feat:, fix:, chore:)
  - 请求 @team-lead 审查
  - 完成后添加 "ready-for-review" 标签
```

### 3. 环境知识
```yaml
name: "开发环境"
trigger: "当设置或运行项目时"
content: |
  - 使用 Node 20 (通过 volta)
  - PostgreSQL 在 Docker 中运行: docker compose up -d db
  - Redis 用于会话管理
  - .env.local 用于本地覆盖（不提交）
```

### 4. 团队约定
```yaml
name: "代码风格偏好"
trigger: "当编写或审查代码时"
content: |
  - 偏好命名导出而非默认导出
  - 使用 TypeScript strict 模式
  - 不用 barrel 文件（index.ts 重导出）
  - 错误处理: 用 Result 类型，不用异常
```

---

## 知识管理操作

### 创建知识
```json
{
  "action": "create",
  "name": "我的知识笔记",
  "content": "内容...",
  "trigger": "何时呈现这个"
}
```

### 更新知识
```json
{
  "action": "update",
  "note_id": "note-<uuid>",
  "content": "更新的内容 - 必须包含所有原始信息加上新增内容"
}
```

### 删除知识
```json
{
  "action": "delete",
  "note_id": "note-<uuid>"
}
```

### 列出知识
```json
{
  "action": "list"
}
```

### 按文件夹组织
```json
{
  "action": "folders"
}
```

---

## 何时创建知识

应该创建知识:
- 用户提供适用于未来会话的指导
- 应持久化的修正或建议
- "始终" 或 "永不" 的指令
- 代码中不明显的仓库结构/约定
- 用户明确说 "记住这个"

不应创建知识:
- 任务特定指令
- 已有知识覆盖的信息
- 通用工程最佳实践
- 特定于一个任务的实现细节
- 密钥或凭据

---

## 知识最佳实践

1. **具体且可操作** — 不是模糊原则
2. **包含命令** — 要运行的精确命令
3. **精确指定触发器** — 何时应该呈现?
4. **内容聚焦** — 每条笔记一个主题
5. **更新而非重复** — 修改已有笔记而非创建新的
6. **包含上下文** — 为什么这个知识重要

---

## 当前知识库状态

**状态**: 空（暂无知识笔记配置）

### 建议创建的初始知识:

1. **仓库约定** — 代码风格、PR 流程
2. **开发设置** — 如何构建/运行/测试
3. **团队偏好** — 命名、架构决策
4. **常见问题** — 已知坑、解决方法
5. **部署流程** — 如何部署、环境说明
