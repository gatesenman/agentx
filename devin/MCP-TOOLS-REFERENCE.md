# MCP 工具完整参考

> MCP (Model Context Protocol) 是智能体连接外部工具和服务的标准协议。
> 本文档列出所有核心工具的完整参数、触发条件和使用场景。

---

## 一、文件操作工具

### read — 读取文件
```yaml
参数:
  file_path: string (必需) — 文件绝对路径
  offset: int (可选) — 从第几行开始读（1-based）
  limit: int (可选) — 读多少行
触发条件: 需要查看文件内容时
注意:
  - 编辑前必须先读取
  - 可读取图片（PNG/JPG）
  - 默认读 5000 字符
  - 超过 2000 字符的行会被截断
使用场景:
  - 理解代码逻辑
  - 检查配置文件
  - 查看测试文件理解预期行为
```

### write — 写入/创建文件
```yaml
参数:
  file_path: string (必需) — 文件绝对路径
  content: string (必需) — 完整文件内容
触发条件: 创建新文件或完全重写
注意:
  - 现有文件必须先读取
  - 优先用 edit 工具做局部修改
  - 不写 emoji 除非用户要求
使用场景:
  - 创建新模块/组件
  - 创建配置文件
  - 生成模板
```

### edit — 精确字符串替换
```yaml
参数:
  file_path: string (必需)
  old_string: string (必需) — 要替换的精确文本
  new_string: string (必需) — 替换后的文本
  replace_all: bool (可选, 默认false) — 替换所有匹配
触发条件: 修改现有文件的一部分
注意:
  - old_string 必须在文件中唯一（否则用更多上下文）
  - 保持原始缩进
  - 编辑前必须先读取文件
使用场景:
  - 修复 bug（修改几行代码）
  - 添加 import
  - 修改配置项
```

### MultiEdit — 单文件批量替换
```yaml
参数:
  file_path: string (必需)
  edits: array (必需) — [{old_string, new_string}, ...]
触发条件: 同一文件需要多处修改
注意:
  - 编辑按顺序应用
  - 后面的编辑看到前面编辑的结果
  - 每个 old_string 必须在当时状态下唯一
使用场景:
  - 重命名变量（多处出现）
  - 修改函数签名和所有调用处
  - 批量修改导入路径
```

### grep — 正则搜索文件内容
```yaml
参数:
  pattern: string (必需) — 正则表达式
  path: string (可选, 默认".") — 搜索目录
  glob_pattern: string (可选) — 文件过滤 (如 "**/*.ts")
  context_lines: int (可选, 默认0) — 上下文行数
  output_mode: enum (可选) — content | files_with_matches | count
  case_insensitive: bool (可选, 默认false)
  max_results: int (可选, 默认100, 最大20000)
触发条件: 在代码库中搜索特定模式
使用场景:
  - 找到函数定义位置
  - 搜索所有使用某个 API 的地方
  - 检查是否有硬编码的密钥
```

### find_file_by_name — 文件名/路径模式匹配
```yaml
参数:
  pattern: string (必需) — glob 模式 (如 "**/*.test.ts")
  path: string (可选) — 搜索目录
触发条件: 按文件名查找（不搜索内容）
使用场景:
  - 找到所有测试文件
  - 找到所有组件文件
  - 检查某个文件是否存在
```

---

## 二、Shell 执行工具

### exec — 执行 Shell 命令
```yaml
参数:
  command: string (必需) — 要执行的命令
  shell_id: string (可选) — Shell 会话ID（持久化）
  timeout: int (可选) — 超时毫秒数
  run_in_background: bool (可选, 默认false) — 后台运行
触发条件: 需要运行命令（安装依赖、运行测试、构建等）
注意:
  - 持久化 shell 会话，工作目录保持
  - 用绝对路径避免 cd
  - 用不同 shell_id 并行运行独立命令
  - 后台模式用于长时间运行的服务器
  - 不要用 sudo git
使用场景:
  - npm install / pip install
  - npm test / pytest
  - npm run build / cargo build
  - git 操作
  - 启动开发服务器（后台模式）
```

### get_output — 读取后台进程输出
```yaml
参数:
  shell_id: string (必需) — Shell 会话ID
  timeout: int (可选) — 等待毫秒数
  incremental: bool (可选, 默认true) — 增量/全量
触发条件: 检查后台进程的输出
使用场景:
  - 监控服务器启动日志
  - 检查长时间运行任务的进度
  - 读取测试输出
```

### write_to_process — 写入交互式进程
```yaml
参数:
  shell_id: string (必需)
  text_input: string (可选) — 文本输入
  bytes_input: string (可选) — 特殊字符 (<CR>, <ESC>, <C-c>)
触发条件: 需要与交互式程序通信
使用场景:
  - 回答安装提示 (y/n)
  - 在 vim/nano 中操作
  - 发送 Ctrl+C 停止进程
```

---

## 三、Git 操作工具

### git_create_pr — 创建 Pull Request
```yaml
参数:
  repo: string (必需) — "github.com/owner/repo"
  title: string (必需)
  body: string (必需) — Markdown 格式
  head_branch: string (必需) — 源分支
  base_branch: string (必需) — 目标分支
  draft: bool (必需) — 是否草稿
前置条件: 必须先调用 fetch_pr_template
触发条件: 代码修改完成，lint 通过
```

### git_view_pr — 查看 PR 详情
```yaml
参数:
  repo: string (必需)
  pull_number: int (必需)
返回: 标题、描述、评论、CI状态、冲突状态、diff
使用场景:
  - 理解已有 PR 的变更
  - 查看 reviewer 评论
  - 检查 CI 状态
```

### git_pr_checks — 检查 CI 状态
```yaml
参数:
  repo: string (必需)
  pull_number: int (必需)
  wait_mode: enum (可选) — all | failure | stage | none
  stage: string (可选) — 等待特定阶段
触发条件: PR 创建后检查 CI
使用场景:
  - 等待所有 CI 通过
  - 快速发现失败
  - 只等特定检查（如 lint）
```

### git_ci_job_logs — 获取 CI 失败日志
```yaml
参数:
  repo: string (必需)
  job_id: int (必需) — 从 git_pr_checks 输出获取
触发条件: CI 失败时需要查看详细日志
```

### git_comment_on_pr — PR 评论
```yaml
参数:
  repo: string (必需)
  pull_number: int (必需)
  body: string (必需) — Markdown
  path: string (可选) — 行内评论的文件路径
  line: int (可选) — 行号
  in_reply_to: int (可选) — 回复特定评论
触发条件: 回复 reviewer 或添加说明
```

### git_update_pr — 更新 PR 标题/描述
```yaml
参数:
  repo: string (必需)
  pull_number: int (必需)
  title: string (可选)
  body: string (可选)
触发条件: 推送新代码后更新描述
```

---

## 四、浏览器/桌面操作工具

### computer — GUI 交互
```yaml
动作类型:
  - screenshot: 截图
  - left_click: 左键点击 (coordinate: [x, y])
  - type: 输入文本 (text: string)
  - key: 按键 (text: "ctrl+a", "Return", "alt+Tab")
  - scroll: 滚动 (scroll_direction, scroll_amount)
  - zoom: 查看区域详情 (region: [x1,y1,x2,y2])
  - wait: 等待 (duration: seconds)
触发条件: 需要与 GUI 交互（浏览器、桌面应用）
注意:
  - 用 Ctrl 不用 Cmd
  - Chrome 已在运行，不要启动/关闭
  - 不发 localhost URL 给用户
  - 用 suggest_open_desktop 让用户看桌面
```

### browser_console — 浏览器控制台
```yaml
参数:
  content: string (可选) — 要执行的 JavaScript
触发条件: 需要检查浏览器错误或运行 JS
使用场景:
  - 检查 console.error
  - 获取 DOM 状态
  - 调试前端逻辑
```

---

## 五、部署工具

### deploy — 部署项目
```yaml
子命令:
  frontend: 部署静态前端到 devinapps.com
    参数: dir (必需) — 含 index.html 的目录
  backend: 部署 FastAPI 到 Fly.io
    参数: dir (必需), volume (可选)
  expose: 暴露本地端口
    参数: port (必需)
  logs: 获取最近日志
触发条件: 用户要求部署或需要公开访问
```

---

## 六、知识和记忆工具

### suggest_knowledge — 建议创建/更新知识
```yaml
参数:
  action: enum — create | update
  value: string (必需) — 知识内容
  trigger: string (create时必需) — 何时检索
  knowledge_id: string (update时必需) — 知识ID
触发条件: 发现可泛化的经验教训
使用场景:
  - 用户说"记住这个"
  - 用户提供的约定/规则
  - 项目特定的操作方式
```

### list_knowledge_notes — 列出所有知识
```yaml
参数: 无
返回: 所有知识条目的ID、名称、范围、大小
```

### get_knowledge_note — 获取知识详情
```yaml
参数:
  knowledge_id: string (必需)
使用场景: 需要查看完整知识内容
```

---

## 七、会话和协作工具

### message_user — 发送消息给用户
```yaml
参数:
  message: string (必需)
  block_on_user: bool (必需) — true=等待回复
  attachments: array (可选) — 文件路径列表
  content_type: enum (可选) — text | user_question
  questions: array (可选) — 可点击选项
  suggest_open_desktop: bool (可选) — 显示"打开桌面"按钮
触发条件: 需要和用户交流
注意:
  - 这是唯一发消息的方式
  - block_on_user=true 只在完成或阻塞时用
  - 简洁，不用 emoji
```

### recording_start / recording_stop — 录屏
```yaml
start 参数: recording_id (可选)
stop 参数: title (必需, ≤5词), summary (必需, ≤4句)
触发条件: UI 测试时录制证据
使用场景:
  - 前端功能验证
  - 用户要求的操作演示
```

### annotate_recording — 录屏标注
```yaml
参数:
  type: enum — setup | test_start | assertion
  description: string (setup时)
  test: string (test_start/assertion时) — "It should ..."
  test_result: enum (assertion时) — passed | failed | untested
  assertion: string (assertion时) — 检查描述
```

---

## 八、MCP 集成服务器

### Devin MCP (devin_mcp)
```yaml
功能: 管理 Devin 会话、Playbook、知识、自动化
核心操作:
  - search_wiki: 搜索代码库文档 (DeepWiki)
  - propose_session: 创建子会话
  - search_sessions: 搜索历史会话
  - list_integrations: 列出集成和MCP服务器
  - create_playbook: 创建Playbook
  - create_knowledge: 创建知识
  - create_schedule: 创建定时任务
  - create_automation: 创建自动化
```

### 常见第三方 MCP 服务器
```yaml
可用集成 (通过 Devin 平台安装):
  - Linear: 项目管理、Issue 跟踪
  - Slack: 消息通知、频道操作
  - Notion: 文档管理
  - Figma: 设计稿获取
  - Sentry: 错误监控
  - Datadog: 性能监控
  - PagerDuty: 事件管理
  - Jira: 项目管理
  - Confluence: 文档协作
  - GitHub: 深度 GitHub 操作
  - GitLab: GitLab 操作
  - Supabase: 数据库操作
  - Vercel: 部署管理
  - AWS: 云服务操作
  - GCP: Google Cloud 操作
  - Stripe: 支付集成
  - Twilio: 通信集成
  - SendGrid: 邮件服务
  - MongoDB: 数据库操作
  - PostgreSQL: 数据库操作
  - Redis: 缓存操作
```

---

## 九、环境和配置工具

### read_environment_config — 读取环境蓝图
```yaml
参数:
  exec_dir: string (可选) — 仓库路径
  target: enum (可选) — repo | org
返回: 当前环境蓝图 YAML
```

### update_environment_config — 更新环境蓝图
```yaml
参数:
  title: string (必需)
  summary: string (必需)
  old_string: string (必需, 空=新建)
  new_string: string (必需)
  exec_dir: string (可选)
  target: enum (可选) — repo | org
触发条件: 安装了新工具/依赖需要持久化
```

### skill — 技能管理
```yaml
命令:
  invoke: 激活技能 (skill: string)
  list: 列出项目技能 (path: string)
  search: 搜索技能 (path: string, keywords: array)
触发条件: 需要使用预定义技能流程
```

---

## 工具选择决策矩阵

| 场景 | 首选工具 | 备选 |
|------|---------|------|
| 查找代码 | grep | find_file_by_name |
| 修改代码 | edit / MultiEdit | write (完全重写时) |
| 运行命令 | exec | — |
| 查看 PR | git_view_pr | — |
| 创建 PR | git_create_pr | — |
| 检查 CI | git_pr_checks | git_ci_job_logs (失败时) |
| 浏览网页 | computer + browser_console | web_search |
| 查找文档 | web_search + web_get_contents | devin_docs |
| 发消息 | message_user | — |
| 部署 | deploy | exec (自定义部署) |
