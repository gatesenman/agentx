# MCP 工具链

MCP（Model Context Protocol）是 AI 智能体的工具调用协议。AgentX 文档化了 50+ 工具的完整使用方法。

---

## 工具分类总览

| 类别 | 工具数量 | 说明 |
|------|---------|------|
| 文件操作 | 7 | 读取、写入、编辑、搜索文件 |
| Shell 执行 | 4 | 命令执行、后台进程、输出读取 |
| 搜索 | 4 | 正则搜索、文件名搜索、Web 搜索 |
| Git / PR | 14 | 创建 PR、查看 PR、CI 检查、评论 |
| 浏览器 | 3 | 桌面交互、控制台、网页内容 |
| 部署 | 1 | 前端/后端部署 |
| 知识管理 | 4 | 知识库 CRUD、技能建议 |
| 环境配置 | 3 | 蓝图读写、密钥管理 |
| 通信 | 2 | 用户消息、阻塞器上报 |
| 笔记本 | 2 | Jupyter Notebook 读写 |
| 任务管理 | 1 | TODO 列表 |
| 录屏 | 3 | 录制、停止、标注 |
| MCP 集成 | 2 | Devin MCP、文档搜索 |

---

## 文件操作工具

### `read` — 读取文件

```
参数:
  file_path: 文件的绝对路径（必填）
  offset: 起始行号，1-based（可选）
  limit: 读取行数（可选）

使用场景:
  - 阅读源代码、配置文件、文档
  - 可读取图片文件（PNG/JPG 等，以视觉形式呈现）
  - 不适用于 .ipynb 文件（使用 notebook_read）

注意:
  - 必须使用绝对路径
  - 默认读取前 5000 字符
  - 超过 2000 字符的行会被截断
```

### `write` — 写入文件

```
参数:
  file_path: 文件的绝对路径（必填）
  content: 文件内容（必填）

使用场景:
  - 创建新文件
  - 完全覆盖现有文件

注意:
  - 必须先 read 过该文件才能 write（防止覆盖错误）
  - 优先使用 edit 而非 write（增量修改）
```

### `edit` — 精确替换

```
参数:
  file_path: 文件的绝对路径（必填）
  old_string: 要替换的原文（必填）
  new_string: 替换后的内容（必填）
  replace_all: 是否替换所有匹配（默认 false）

使用场景:
  - 修改代码的特定部分
  - 重命名变量/函数（replace_all=true）

注意:
  - old_string 必须在文件中唯一
  - 必须先 read 过文件
  - 保持原始缩进（tab/空格）
```

### `MultiEdit` — 批量替换

```
参数:
  file_path: 文件的绝对路径（必填）
  edits: 编辑操作数组，每个含 old_string 和 new_string

使用场景:
  - 同一文件中多处修改
  - 原子操作（要么全部成功，要么全部失败）

注意:
  - 编辑按顺序应用（后面的编辑看到前面的结果）
  - 比多次 edit 调用更高效
```

---

## Shell 执行工具

### `exec` — 执行命令

```
参数:
  command: 要执行的命令（必填）
  shell_id: Shell 会话 ID（可选，默认 "default"）
  run_in_background: 后台运行（默认 false）
  timeout: 超时毫秒数（可选）

使用场景:
  - 运行 git、npm、docker 等命令
  - 启动服务器（run_in_background=true）
  - 运行测试、lint、构建

注意:
  - 不要用于文件操作（有专用工具）
  - 使用绝对路径避免 cd
  - 包含空格的路径用双引号
  - 相同 shell_id 的命令不能并行
```

### `get_output` — 读取后台输出

```
参数:
  shell_id: Shell 会话 ID（必填）
  timeout: 等待毫秒数（可选，默认 100ms）
  incremental: 是否只返回新输出（默认 true）

使用场景:
  - 检查后台进程的输出
  - 等待命令完成
```

### `write_to_process` — 写入交互进程

```
参数:
  shell_id: Shell 会话 ID（必填）
  text_input: 文本输入
  bytes_input: 特殊字符（如 <CR>, <ESC>, <C-c>）

使用场景:
  - 与交互式程序通信（vim, top 等）
  - 发送 Ctrl+C 终止进程
```

---

## 搜索工具

### `grep` — 内容搜索

```
参数:
  pattern: 正则表达式（必填）
  path: 搜索目录/文件（默认当前目录）
  glob_pattern: 文件过滤模式（如 "*.py"）
  case_insensitive: 不区分大小写（默认 false）
  context_lines: 上下文行数（默认 0）
  output_mode: "content" | "files_with_matches" | "count"

使用场景:
  - 搜索函数/类/变量的使用位置
  - 检查错误信息来源
  - 统计代码模式出现次数
```

### `find_file_by_name` — 文件名搜索

```
参数:
  pattern: glob 模式（必填，如 "**/*.ts"）
  path: 搜索目录（可选）

使用场景:
  - 查找特定类型的文件
  - 定位配置文件位置
```

### `web_search` — 网页搜索

```
参数:
  query: 搜索关键词（必填）
  num_results: 结果数量（默认 5）
  domain: 限定域名

使用场景:
  - 查找文档和 API 参考
  - 搜索错误信息的解决方案
```

### `web_get_contents` — 获取网页内容

```
参数:
  urls: URL 列表（最多 10 个）

使用场景:
  - 读取文档全文
  - 配合 web_search 使用
```

---

## Git / PR 工具

### 创建和管理 PR

| 工具 | 功能 |
|------|------|
| `fetch_pr_template` | 获取 PR 模板（创建 PR 前必调用） |
| `git_create_pr` | 创建 PR |
| `git_update_pr` | 更新 PR 标题/描述 |
| `git_view_pr` | 查看 PR 详情（diff、评论、CI） |
| `git_close_pr` | 关闭 PR |
| `git_update_pr_base` | 更改 PR 的 base 分支 |
| `git_take_over_pr` | 接管已有 PR |

### CI 和评论

| 工具 | 功能 |
|------|------|
| `git_pr_checks` | 查看/等待 CI 状态 |
| `git_ci_job_logs` | 获取 CI job 详细日志 |
| `git_comment_on_pr` | PR 评论（支持行内评论） |
| `git_edit_comment` | 编辑已有评论 |
| `git_delete_comment` | 删除评论 |
| `git_add_labels` | 添加标签 |
| `git_remove_labels` | 移除标签 |

### PR 工作流示例

```
1. fetch_pr_template(repo="owner/repo")
2. git_create_pr(repo, title, body, head_branch, base_branch, draft=false)
3. git_pr_checks(repo, pull_number, wait_mode="all")
   ├─ 全部通过 → 通知用户
   └─ 有失败 → git_ci_job_logs(repo, job_id) → 修复 → 重新推送
```

---

## 浏览器和桌面工具

### `computer` — 桌面交互

```
操作类型:
  - screenshot: 截图
  - left_click / right_click / double_click: 鼠标点击
  - type: 输入文字
  - key: 按键（如 "ctrl+c", "Return"）
  - scroll: 滚动
  - zoom: 查看特定区域细节

使用场景:
  - 测试 Web UI
  - 浏览器操作
  - 截图取证
```

### `browser_console` — 浏览器控制台

```
参数:
  content: JavaScript 代码（可选，为空则只返回控制台输出）

使用场景:
  - 执行 JS 代码
  - 检查控制台错误
```

---

## 部署工具

### `deploy`

```
子命令:
  - frontend: 部署静态前端到 devinapps.com
  - backend: 部署 FastAPI 后端到 Fly.io
  - expose: 暴露本地端口到公网
  - logs: 获取最近部署日志
```

---

## 知识管理工具

| 工具 | 功能 |
|------|------|
| `list_knowledge_notes` | 列出所有知识笔记 |
| `get_knowledge_note` | 获取笔记详情 |
| `suggest_knowledge` | 建议创建/更新知识 |
| `suggest_skill_pr` | 建议创建技能 PR |

---

## 任务管理

### `todo_write`

```
参数:
  todos: 任务列表数组，每项含 content 和 status
  status: "pending" | "in_progress" | "completed"

使用场景:
  - 复杂任务的分步追踪
  - 向用户展示进度
  - 确保不遗漏任何步骤
```

---

## 工具选择决策树

```
需要什么？
    │
    ├─ 读取文件内容 → read
    ├─ 修改文件部分内容 → edit / MultiEdit
    ├─ 创建/覆盖文件 → write
    ├─ 搜索文件内容 → grep
    ├─ 搜索文件名 → find_file_by_name
    ├─ 运行命令 → exec
    ├─ 创建 PR → fetch_pr_template → git_create_pr
    ├─ 查看 PR → git_view_pr
    ├─ 等待 CI → git_pr_checks
    ├─ 浏览器操作 → computer
    ├─ 搜索网页 → web_search → web_get_contents
    ├─ 部署应用 → deploy
    └─ 管理任务 → todo_write
```

---

## 相关文档

- [工作流系统](工作流系统.md) — 工作流中如何组合工具
- [记忆系统](记忆系统.md) — 知识管理工具的详细使用
- [安全策略](安全策略.md) — 密钥管理工具
