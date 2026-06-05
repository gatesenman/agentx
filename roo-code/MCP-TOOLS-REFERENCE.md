# MCP 工具完整参考

> 所有 Devin 可用的 50+ 工具及其用法。

## 一、文件操作工具

### read — 读取文件
```
参数: file_path(必需), offset(可选), limit(可选)
用法: 读取文件内容，支持分页
注意: 编辑前必须先读取
```

### write — 写入文件
```
参数: file_path(必需), content(必需)
用法: 创建或覆盖文件
注意: 现有文件必须先读取
```

### edit — 精确替换
```
参数: file_path(必需), old_string(必需), new_string(必需), replace_all(可选)
用法: 替换文件中的特定字符串
注意: old_string 必须在文件中唯一
```

### MultiEdit — 批量替换
```
参数: file_path(必需), edits(必需, 数组)
用法: 在一个文件中执行多个替换操作
注意: 编辑按顺序应用
```

### grep — 搜索内容
```
参数: pattern(必需), path(可选), glob_pattern(可选), context_lines(可选)
输出模式: content | files_with_matches | count
用法: 正则搜索文件内容
```

### find_file_by_name — 搜索文件名
```
参数: pattern(必需), path(可选)
用法: 按 glob 模式搜索文件路径
示例: pattern="**/*.ts" 递归搜索所有 .ts 文件
```

## 二、Shell 和进程工具

### exec — 执行命令
```
参数: command(必需), shell_id(可选), run_in_background(可选), timeout(可选)
用法: 在持久 shell 中执行命令
注意:
  - 工作目录在命令间保持
  - 用 shell_id 创建多个并行 shell
  - 永不在同一 shell_id 上并行运行
  - run_in_background=true 用于长进程
  - 环境变量加载需要单独命令
```

### get_output — 读取后台输出
```
参数: shell_id(必需), timeout(可选)
用法: 读取后台进程的输出
```

### write_to_process — 写入交互进程
```
参数: shell_id(必需), text_input(可选), bytes_input(可选)
用法: 向运行中的交互程序发送输入
特殊字符: <ESC>, <CR>, <UP>, <DOWN>, <C-c>, <C-d>
```

### kill_shell — 终止 shell
```
参数: shell_id(必需)
用法: 终止后台 shell 进程
```

## 三、Git 和 PR 工具

### git_create_pr — 创建 PR
```
参数: repo, title, body, head_branch, base_branch, draft
前提: 必须先调用 fetch_pr_template
```

### git_view_pr — 查看 PR
```
参数: repo, pull_number
返回: 标题、描述、评论、CI 状态、合并冲突状态
```

### git_update_pr — 更新 PR
```
参数: repo, pull_number, title(可选), body(可选), force(可选)
```

### git_pr_checks — CI 状态
```
参数: repo, pull_number, wait_mode(可选), stage(可选)
等待模式:
  - all: 等待所有检查完成（默认）
  - failure: 等到有失败就返回
  - stage: 等特定阶段完成
  - none: 立即返回当前状态
```

### git_ci_job_logs — CI 日志
```
参数: repo, job_id
用法: 获取特定 CI job 的详细日志
```

### git_comment_on_pr — PR 评论
```
参数: repo, pull_number, body, path(可选), line(可选), in_reply_to(可选)
用法: 发表评论、行内评论、回复评论
```

### git_take_over_pr — 接管 PR
```
参数: repo, pull_number
用法: 接管已有 PR，接收后续通知
```

### git_add_labels / git_remove_labels — 标签管理
```
参数: repo, pull_number, labels
```

### git_close_pr — 关闭 PR
```
参数: repo, pull_number
```

### git_update_pr_base — 更改 base branch
```
参数: repo, pull_number, base_branch
```

### fetch_pr_template — 获取 PR 模板
```
参数: repo, include_diff(可选)
用法: 创建 PR 前必须调用
```

### git_list_repos — 列出仓库
```
参数: filter_name(可选), page(可选)
```

## 四、浏览器和 GUI 工具

### computer — 桌面交互
```
操作: screenshot, left_click, type, key, scroll, mouse_move, zoom, wait...
注意:
  - 用 Ctrl 不用 Cmd
  - Chrome 已在运行，永不启动/关闭
  - 前台 Chrome 时返回 annotated DOM (devinid 属性)
  - 打开 URL: 点地址栏 → Ctrl+A → 输入 URL → 回车
```

### browser_console — 浏览器控制台
```
参数: content(可选, JavaScript 代码)
用法: 查看控制台输出或执行 JS
```

## 五、通信工具

### message_user — 发送消息
```
参数: message, block_on_user, attachments(可选), suggest_open_desktop(可选),
      content_type(可选), questions(可选)
注意:
  - block_on_user=true: 完成或被阻塞时
  - block_on_user=false: 进度更新
  - content_type="user_question": 可点击选项
  - 永不发 localhost URL
```

### request_secret — 请求密钥
```
参数: secret_name, type(可选), should_save(可选), save_scope(可选)
类型: plain | totp
保存范围: org | user | repo
```

### list_secrets — 列出密钥
```
返回: 已配置密钥的名称和类型（不含值）
```

## 六、部署工具

### deploy — 部署应用
```
子命令:
  - frontend: 静态站点 → devinapps.com
  - backend: FastAPI → Fly.io
  - logs: 查看后端日志
  - expose: 暴露本地端口
```

## 七、录屏工具

### recording_start — 开始录屏
### recording_stop — 停止录屏
```
参数: title(必需), summary(必需)
```

### annotate_recording — 添加注释
```
类型: setup | test_start | assertion
```

## 八、环境工具

### read_environment_config — 读取蓝图
### update_environment_config — 更新蓝图
```
参数: title, summary, old_string, new_string, target(可选: repo|org)
```

## 九、任务管理工具

### todo_write — 管理待办
```
参数: todos(数组, 含 content + status)
状态: pending | in_progress | completed
```

### enter_test_mode — 进入测试模式

## 十、知识和技能工具

### list_knowledge_notes — 列出知识笔记
### get_knowledge_note — 获取笔记内容
### suggest_knowledge — 建议知识项
### skill — 管理技能
```
命令: invoke | list | search
```

## 十一、Devin MCP 工具

### devin_mcp — MCP 服务器
```
命令: list_tools | call_tool
可用工具:
  - read_wiki_structure: 获取仓库文档结构
  - read_wiki_contents: 查看仓库文档
  - ask_question: AI 问答
  - generate_wiki: 生成代码库 wiki
  - devin_session_create: 创建子会话
  - devin_session_interact: 交互会话
  - devin_session_search: 搜索会话
  - devin_session_gather: 等待多个会话
  - devin_session_events: 检查会话事件
  - devin_knowledge_manage: 知识管理
  - devin_playbook_manage: Playbook 管理
  - devin_schedule_manage: 定时任务管理
  - list_integrations: 列出集成
```

### devin_docs — 文档搜索
```
工具: search_devin_docs
参数: query
```

## 十二、其他工具

### web_search — 网页搜索
### web_get_contents — 获取网页内容
### upload_attachment — 上传文件获取 URL
### report_blocker — 报告阻塞
### save_browser_profile — 保存浏览器配置
### read_build_logs — 查看构建日志
### suggest_skill_pr — 建议技能 PR
### suggest_save_secret — 建议保存密钥
### notebook_read / notebook_edit — Jupyter 操作
