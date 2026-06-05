# Devin 自动化与钩子

## 概述

Devin 支持事件驱动的自动化，根据外部事件自动触发会话。

---

## 自动化类型

### 1. PR 审查自动化
**触发器**: 新 PR 创建或更新
**动作**: 自动审查代码，建议改进，检查问题

```yaml
name: 自动 PR 审查
trigger:
  event: pull_request
  actions: [opened, synchronize]
  repos: ["owner/repo"]
prompt: |
  审查此 PR:
  - 代码质量问题
  - 潜在 bug
  - 缺失的测试
  - 安全隐患
  以 PR 评论形式提供建设性反馈。
```

### 2. Issue 分类自动化
**触发器**: 新 issue 创建
**动作**: 分析 issue，添加标签，建议负责人

```yaml
name: Issue 分类
trigger:
  event: issues
  actions: [opened]
  repos: ["owner/repo"]
prompt: |
  分析此 issue:
  - 分类（bug, feature, docs 等）
  - 评估优先级
  - 建议相关标签
  - 如果是简单 bug，尝试修复
```

### 3. 定时维护
**触发器**: Cron 定时
**动作**: 执行维护任务

```yaml
name: 每周依赖更新
schedule: "0 9 * * 1"  # 每周一 9 AM
repo: "owner/repo"
prompt: |
  检查过期依赖。
  如果有安全更新:
  - 更新它们
  - 运行测试
  - 创建包含更新的 PR
```

### 4. CI 失败自动修复
**触发器**: CI 检查失败
**动作**: 尝试自动修复

```yaml
name: 自动修复 CI
trigger:
  event: check_run
  actions: [completed]
  conclusion: [failure]
  repos: ["owner/repo"]
prompt: |
  此 PR 的 CI 失败了。调查原因:
  - 阅读 CI 日志
  - 识别根因
  - 如果是简单修复（lint、类型错误），修复它
  - 如果复杂，留下评论解释问题
```

---

## 钩子模式

### Pre-commit Hooks（Git 级别）
提交前本地运行:
```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.3.0
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format
```

### 会话生命周期钩子

**会话启动时:**
- 加载环境蓝图
- 运行维护命令
- 呈现知识笔记
- 检查活跃的自动化

**PR 创建后:**
- 运行 CI 检查
- 触发审查自动化
- 检查预览部署
- 通知相关人员

**会话完成时:**
- 如发现新知识则建议知识更新
- 如发现新模式则建议技能 PR
- 报告任何摩擦阻塞

---

## 通过 MCP 创建自动化

```javascript
// 使用 devin_schedule_manage 创建自动化
{
  "action": "create",
  "cron": "0 */6 * * *",        // 每 6 小时
  "prompt": "检查新 issue 并分类",
  "repo": "owner/repo",
  "title": "Issue 分类机器人"
}
```

---

## 事件驱动自动化配置

自动化通过 Devin 网页 UI 配置:
- 导航到: 设置 > 自动化
- URL: https://app.devin.ai/settings/automations

### 配置字段:
| 字段 | 描述 |
|------|------|
| 名称 | 可读的自动化名称 |
| 触发事件 | GitHub webhook 事件类型 |
| 仓库 | 监听哪个仓库 |
| 提示词 | 触发会话的指令 |
| 过滤器 | 额外条件（标签、路径等） |
| Playbook | 可选的 playbook |

---

## 最佳实践

1. **保持提示词具体** — 模糊指令导致不一致结果
2. **设置适当过滤器** — 避免每个事件都触发
3. **包含失败处理** — 告诉自动化无法完成时怎么做
4. **先做测试运行** — 启用前验证自动化行为
5. **监控结果** — 定期检查自动化会话结果
6. **使用 Playbook** — 复杂多步自动化引用 playbook
