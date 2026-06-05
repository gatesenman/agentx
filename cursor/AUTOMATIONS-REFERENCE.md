# 自动化和 Hook 完整参考

## 自动化类型

### 1. PR 审查自动化
```yaml
触发器: 新 PR 创建或更新
行为:
  - 自动审查代码变更
  - 检查编码规范
  - 检查安全问题
  - 检查测试覆盖
  - 发表审查评论

配置 (通过 Devin 平台):
  name: "PR 自动审查"
  trigger: "pr_created, pr_updated"
  prompt: |
    审查这个 PR 的代码变更:
    1. 检查代码质量和编码规范
    2. 检查潜在 bug 和安全问题
    3. 检查是否有遗漏的测试
    4. 给出改进建议
```

### 2. Issue 分诊自动化
```yaml
触发器: 新 Issue 创建
行为:
  - 分析 Issue 内容
  - 自动添加标签
  - 识别关键词分类
  - 必要时请求更多信息

配置:
  name: "Issue 自动分诊"
  trigger: "issue_created"
  prompt: |
    分析这个 Issue:
    1. 判断类型 (bug/feature/question)
    2. 评估优先级
    3. 添加相关标签
    4. 如果信息不足，请求补充
```

### 3. 定时维护自动化
```yaml
触发器: Cron 定时 (通过 Devin Schedules)
行为:
  - 检查依赖更新
  - 运行安全扫描
  - 生成报告

配置 (通过 devin_schedule_manage):
  cron: "0 9 * * 1"  # 每周一 9:00
  prompt: |
    执行每周维护:
    1. 检查过时的依赖
    2. 运行安全审计
    3. 生成报告发送给我
```

### 4. CI 失败自动修复
```yaml
触发器: CI 检查失败
行为:
  - 获取失败日志
  - 分类失败类型
  - 尝试自动修复
  - 推送修复并等待 CI

配置:
  name: "CI 自动修复"
  trigger: "ci_failed"
  prompt: |
    CI 失败了，请:
    1. 查看失败日志
    2. 如果是 lint/格式问题，自动修复
    3. 如果是测试失败，分析根因并尝试修复
    4. 最多尝试 3 次
```

## 会话生命周期钩子

### 系统注入时序
```
会话启动
│
├─ 1. 系统提示词注入（核心规则、工具定义）
├─ 2. 环境信息注入（OS、路径、日期时间）
├─ 3. 会话信息注入（Session ID、URL）
├─ 4. 身份信息注入（Devin ID、User ID、Org ID）
├─ 5. 可用技能列表注入
├─ 6. 知识笔记注入（匹配触发条件的）
├─ 7. 规则注入（<rules> 块）
├─ 8. 环境蓝图 knowledge 呈现
│
├─ 用户消息到达
│  ├─ <system_note>: 系统通知（静默处理）
│  ├─ <system_guidance>: 决策指导（融入行为）
│  ├─ <system_update>: 外部事件（需要响应）
│  ├─ <knowledge-hints>: 知识提示（酌情采纳）
│  └─ 用户文本: 正常处理
│
└─ 会话结束
   └─ 报告 friction 级别问题（如有）
```

### 工具调用钩子
```
工具调用前:
  - 参数验证
  - 权限检查
  - 依赖检查（如 read 前检查文件是否存在）

工具调用后:
  - 输出截断检查（>限制 → 写入文件 → truncation_notice）
  - 错误处理
  - 状态更新

特殊钩子:
  - git_create_pr: 自动追加 Session URL
  - computer (Chrome 前台): 自动返回 annotated DOM
  - exec (输出过长): 自动截断 + 写入溢出文件
  - skill invoke: 技能成为主要指令源
```

## 事件驱动配置

### 通过 Devin MCP 创建自动化
```
工具: devin_mcp
命令: call_tool
tool_name: 通过 list_integrations 查看可用集成

步骤:
1. devin_mcp list_tools → 发现可用操作
2. 创建 Knowledge Note 定义行为规则
3. 创建 Playbook 定义工作流程
4. 设置 Schedule 定义触发时间
5. 配置 Automation 关联触发器和行为
```

## 最佳实践

```
自动化设计原则:
  ✓ 每个自动化只做一件事
  ✓ Prompt 要自包含（不依赖外部上下文）
  ✓ 设置合理的超时和重试限制
  ✓ 失败时通知用户而不是静默失败
  ✓ 测试自动化后再启用

避免:
  ✗ 过于复杂的自动化链
  ✗ 没有失败处理的自动化
  ✗ 修改代码但不创建 PR 的自动化
  ✗ 包含硬编码密钥的自动化
```
