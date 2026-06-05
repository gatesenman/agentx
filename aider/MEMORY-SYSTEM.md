# 记忆与知识系统完整参考

> 智能体的记忆系统负责跨会话的知识持久化和上下文管理。
> 包含 7 层记忆机制，从短期到永久。

---

## 一、记忆系统架构（7 层）

```
┌─────────────────────────────────────────────────┐
│  第7层: 浏览器配置 (Browser Profile)              │
│  - Cookie、登录状态、LocalStorage                 │
│  - 跨会话持久化浏览器状态                         │
├─────────────────────────────────────────────────┤
│  第6层: 环境蓝图 (Blueprint)                      │
│  - VM 初始化脚本                                  │
│  - 依赖安装、工具配置                             │
│  - 快照化为 VM 镜像                              │
├─────────────────────────────────────────────────┤
│  第5层: 密钥存储 (Secrets)                        │
│  - 组织级 / 用户级 / 仓库级                       │
│  - 环境变量注入                                   │
│  - TOTP 自动生成                                  │
├─────────────────────────────────────────────────┤
│  第4层: Playbook (可复用流程)                     │
│  - 预定义的任务模板                               │
│  - 带参数的执行流程                               │
│  - 可被调度/自动化触发                            │
├─────────────────────────────────────────────────┤
│  第3层: 技能 (Skills / SKILL.md)                  │
│  - 项目级的操作指南                               │
│  - 存储在 .devin/skills/ 或 .agents/skills/       │
│  - 有 YAML frontmatter (name, description)       │
│  - 按需激活                                       │
├─────────────────────────────────────────────────┤
│  第2层: 知识笔记 (Knowledge Notes)               │
│  - 用户/系统创建的可泛化经验                      │
│  - 有触发范围(trigger/scope)                      │
│  - 自动注入相关上下文                             │
│  - 可通过 suggest_knowledge 建议创建             │
├─────────────────────────────────────────────────┤
│  第1层: 会话记忆 (Session Memory)                 │
│  - 当前对话上下文                                 │
│  - TODO 清单                                     │
│  - 自动摘要（长对话时）                           │
│  - 会话结束后归档                                 │
└─────────────────────────────────────────────────┘
```

---

## 二、知识笔记 (Knowledge Notes)

### 创建时机
- 用户提供了可泛化的指导（"以后都这样做"）
- 发现了项目特有的操作方式
- 用户明确说"记住这个"
- 纠正了反复出现的错误

### 不创建的情况
- 任务特定的指令（不会泛化）
- 已有知识中已涵盖
- 通用工程最佳实践
- 当前任务的实现细节
- 任何密钥/凭据

### 知识结构
```yaml
# 创建知识
action: create
value: |
  在此仓库中运行测试前，必须先启动 Docker:
  docker-compose up -d postgres redis
  然后等待 10 秒让服务就绪。
trigger: "在 myapp 仓库中运行测试时"

# 更新知识
action: update
knowledge_id: "note-abc123"
value: |
  （包含原有内容 + 新增内容）
```

### 知识注入方式
```xml
<!-- 系统自动注入相关知识到对话中 -->
<knowledge id="note-abc123" name="测试前准备" author="user">
在此仓库中运行测试前，必须先启动 Docker...
</knowledge>
```

---

## 三、技能系统 (Skills)

### 目录结构
```
.devin/skills/
├── testing/
│   └── SKILL.md
├── deployment/
│   └── SKILL.md
├── code-review/
│   └── SKILL.md
└── login-flow/
    └── SKILL.md
```

### SKILL.md 格式
```markdown
---
name: my-skill-name
description: 何时使用此技能的简短描述
---

# 技能名称

## 前置条件
- 需要什么环境/工具/权限

## 步骤
1. 第一步...
2. 第二步...

## 验证
如何确认技能成功执行
```

### 技能使用规则
- 技能激活后成为主要指令源
- 严格按步骤顺序执行
- 不跳步、不合并步骤、不替换方案
- 步骤失败时排障，不静默跳过
- 完成后对照技能检查是否漏步

---

## 四、Playbook (可复用流程模板)

### 结构
```yaml
name: "Bug 修复流程"
description: "标准 bug 修复和 PR 创建流程"
prompt: |
  1. 搜索理解 bug 上下文
  2. 定位根因
  3. 实现修复
  4. 运行测试验证
  5. 创建 PR
parameters:
  - name: issue_url
    description: "Issue 链接"
  - name: branch_name
    description: "分支名（可选）"
```

### Playbook vs Skill
| 维度 | Playbook | Skill |
|------|----------|-------|
| 存储 | Devin 平台 | 仓库 .devin/skills/ |
| 触发 | 手动/调度/自动化 | 按需激活 |
| 参数 | 支持参数化 | 无参数 |
| 版本 | 平台管理 | Git 版本控制 |
| 可见 | 组织内 | 仓库内 |

---

## 五、密钥管理 (Secrets)

### 层级
```
组织级 (org) — 所有 Devin 会话共享
  └── 例: 共享 API key, 团队 AWS 凭据
用户级 (user) — 个人专用
  └── 例: 个人 GitHub token, 个人邮箱密码
仓库级 (repo) — 特定仓库
  └── 例: 特定项目的 deploy key
```

### 在 Shell 中使用
```bash
# 普通密钥
curl -H "Authorization: Bearer ${API_KEY}" https://api.example.com

# TOTP 密钥 (自动生成当前6位码)
echo ${_2FA_GITHUB}  # 输出: 123456
```

### 请求密钥协议
```yaml
场景: 任务需要认证信息
流程:
  1. 检查是否已有 (list_secrets)
  2. 如果没有，提供三选项:
     - 跳过（设计绕过方案）
     - 临时（should_save=false）
     - 永久（should_save=true, save_scope=org/user/repo）
  3. 提供可操作的配置命令
规则:
  - 用描述性名称 (AWS_DEVIN_TESTING_KEY, 不是 KEY)
  - TOTP 前缀 _2FA_
  - 多个缺失时批量请求
  - 绝不在代码/日志中暴露
```

---

## 六、环境蓝图 (Blueprint)

### 结构
```yaml
# 仓库级蓝图
initialize: |
  # 只运行一次（构建快照时）
  curl -LsSf https://astral.sh/uv/install.sh | sh
  npm install -g pnpm

maintenance: |
  # 每次会话开始前运行
  pnpm install
  (cd packages/api && uv sync)

knowledge:
  - name: lint
    contents: pnpm run lint
  - name: test
    contents: pnpm test
  - name: startup
    contents: pnpm dev
```

### 蓝图规则
- `initialize`: 文件系统持久化，进程不持久化
- `maintenance`: 增量命令（npm install 不是 npm ci）
- 不在两个 section 放相同命令
- 不放密钥（用 $VARIABLE_NAME）
- 只放已验证可工作的命令
- 组织级蓝图先于仓库级运行

---

## 七、浏览器配置持久化

### 保存时机
- 用户说"保存浏览器状态"
- 登录完成后需要保持登录
- 安装了浏览器扩展

### 工作方式
```
save_browser_profile
  → 打包 Chrome user data directory
  → 存储到云端
  → 未来会话自动恢复
  → Cookie/密码/LocalStorage 全保留
```

---

## 八、会话摘要系统

### 自动摘要
- 长对话自动压缩为摘要
- 保留: 关键决策、文件路径、代码片段、TODO 状态
- 丢弃: 探索性搜索、重复尝试、详细日志

### 摘要包含
```
1. 主要请求和意图
2. 关键概念和技术选择
3. 任务需求和限制
4. 重要文件和代码片段
5. 遇到的错误和解决方案
6. 问题解决记录
7. 待办任务
8. 当前进度
9. 下一步计划
```

---

## 九、跨会话记忆流转

```
会话 N 结束
  │
  ├── 知识笔记 → 永久保存，未来会话自动注入
  ├── 技能文件 → 提交到仓库，未来会话可激活
  ├── 密钥 → 永久保存，自动注入环境变量
  ├── 蓝图 → 构建快照，未来会话从快照启动
  ├── 浏览器配置 → 保存并恢复
  └── 会话摘要 → 归档（可搜索）
  │
  ▼
会话 N+1 启动
  │
  ├── 从快照启动 VM（蓝图已执行）
  ├── 密钥注入环境变量
  ├── 浏览器配置恢复
  ├── 相关知识自动注入对话
  └── 技能可按需激活
```
