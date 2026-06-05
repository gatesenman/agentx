# 决策引擎完整参考

> 智能体在面对不同场景时的决策逻辑树。
> 每个决策点都有明确的判断条件和对应行动。

---

## 一、任务路由决策

```
用户消息到达
│
├── 是否是简单问题？(如 "2+2?", "这个函数干啥?")
│   ├── 是 → 直接回答，不创建 PR
│   └── 否 → 继续分析
│
├── 是否需要代码变更？
│   ├── 否 (只是探索/分析)
│   │   └── 搜索、阅读、分析，报告结果
│   ├── 是
│   │   ├── 用户说了"不要 PR" → 本地修改
│   │   ├── 用户说了"draft PR" → 创建草稿 PR
│   │   └── 默认 → 创建正式 PR
│   └── 不确定
│       └── 推断最可能有用的行动 + 确认
│
├── 是否涉及多个独立子任务？
│   ├── 是 → 考虑拆分（多 PR 或子会话）
│   └── 否 → 单一工作流
│
└── 任务复杂度
    ├── 简单 (1-2 步) → 直接执行
    ├── 中等 (3-5 步) → 创建 TODO
    └── 复杂 (5+ 步) → 创建详细 TODO + 发送计划
```

---

## 二、工具选择决策

```
需要做什么？
│
├── 搜索代码内容
│   ├── 搜索正则模式 → grep
│   ├── 搜索文件名 → find_file_by_name
│   └── 搜索代码语义 → devin_mcp(search_wiki)
│
├── 修改代码
│   ├── 新建文件 → write
│   ├── 修改少量行 → edit
│   ├── 同文件多处修改 → MultiEdit
│   └── 完全重写文件 → write (先 read)
│
├── 运行命令
│   ├── 快速命令 (ls, cat, git) → exec
│   ├── 长时间运行 (server) → exec(run_in_background=true)
│   └── 交互式程序 (vim) → exec + write_to_process
│
├── Git/PR 操作
│   ├── 创建 PR → fetch_pr_template + git_create_pr
│   ├── 查看 PR → git_view_pr
│   ├── 检查 CI → git_pr_checks
│   ├── CI 失败日志 → git_ci_job_logs
│   ├── PR 评论 → git_comment_on_pr
│   └── 更新 PR → git_update_pr
│
├── 浏览器操作
│   ├── 截图查看状态 → computer(screenshot)
│   ├── 点击/输入 → computer(left_click/type)
│   ├── 运行 JS → browser_console
│   └── 搜索网络信息 → web_search + web_get_contents
│
└── 通信
    ├── 更新进度 → message_user(block=false)
    ├── 完成/阻塞 → message_user(block=true)
    ├── 提供选项 → message_user(content_type="user_question")
    └── 展示桌面 → message_user(suggest_open_desktop=true)
```

---

## 三、并行 vs 顺序执行决策

```
有多个操作要做
│
├── 操作之间有依赖？
│   ├── 是 (后面的需要前面的结果)
│   │   └── 顺序执行
│   └── 否 (完全独立)
│       └── 并行执行
│
├── 具体场景:
│   ├── 读取 3 个文件 → 并行 (3 个 read 同时发)
│   ├── 读文件 + 基于内容编辑 → 顺序 (先 read 再 edit)
│   ├── 运行测试 + lint → 并行 (不同 shell_id)
│   ├── 安装依赖 + 运行测试 → 顺序 (需要先安装)
│   └── 发消息 + 继续工作 → 并行 (message 不阻塞时)
```

---

## 四、错误处理决策

```
遇到错误
│
├── 错误类型判断:
│   ├── 基础设施错误 (连接失败, DNS, 权限被拒)
│   │   ├── 重试次数 < 4 → 重试
│   │   └── 重试次数 >= 4 → 停止 + 上报
│   │
│   ├── 任务级错误 (代码bug, 测试失败, lint错误)
│   │   └── 持续尝试解决（不放弃）
│   │       ├── 搜索错误信息
│   │       ├── 查看相关代码
│   │       ├── 尝试不同方案
│   │       └── 穷尽选项后 → 问用户
│   │
│   ├── CI 失败
│   │   ├── 第 1-3 次 → 查看日志，修复，推送
│   │   └── 第 4 次 → 向用户求助
│   │
│   └── pre-commit hook 失败
│       ├── 第 1 次 → 让 hook 修改，重新提交
│       └── 第 2 次 → 检查 hook 修改的文件，一起提交

```

---

## 五、Git 操作决策

```
需要 Git 操作
│
├── 提交代码
│   ├── 哪些文件要提交？ → 只添加相关文件 (不 git add .)
│   ├── 提交信息格式？ → conventional commits
│   ├── pre-commit 失败？ → 重试一次，然后提交 hook 修改的文件
│   └── 需要修复之前的提交？ → 新 commit (绝不 amend)
│
├── 推送代码
│   ├── 目标分支是 main/master？ → 拒绝（用 feature branch + PR）
│   ├── 推送被拒绝（远端有新提交）？ → git pull --rebase + push
│   └── feature branch 需要 force push？ → --force-with-lease
│
├── 分支操作
│   ├── 创建新分支 → devin/$(date +%s)-描述
│   ├── 切换分支 → git checkout / git switch
│   └── 删除分支 → 只删自己的 feature branch
│
├── 查看历史
│   ├── 先检查 → git rev-parse --is-shallow-repository
│   ├── 如果 shallow → git fetch --unshallow
│   └── 然后运行 git log / blame / bisect
│
└── 合并/冲突
    ├── 简单冲突 → 自动解决
    ├── 复杂冲突 → 问用户
    └── cherry-pick 多个 → 每步报告进度
```

---

## 六、PR 创建决策

```
代码修改完成
│
├── 检查清单:
│   ├── lint 通过？
│   │   ├── 否 → 修复 lint 错误
│   │   └── 是 → 继续
│   ├── typecheck 通过？
│   │   ├── 否 → 修复类型错误
│   │   └── 是 → 继续
│   └── 有测试覆盖？
│       ├── 用户要求写测试 → 写测试
│       └── 用户没要求 → 跳过
│
├── 创建 PR:
│   ├── 获取 PR 模板 (fetch_pr_template)
│   ├── 写描述 (高信号, 高信息熵)
│   ├── 设置 base branch
│   ├── draft 还是正式？
│   │   ├── 用户说了 draft → draft=true
│   │   └── 默认 → draft=false
│   └── 创建 (git_create_pr)
│
├── 等待 CI:
│   ├── git_pr_checks(wait_mode="all")
│   ├── 全部通过 → 通知用户
│   ├── 有失败:
│   │   ├── 获取日志 (git_ci_job_logs)
│   │   ├── 分析失败原因
│   │   ├── 修复 + 推送新 commit
│   │   ├── 重复最多 3 次
│   │   └── 仍然失败 → 向用户求助
│   └── 检查预览 URL → 包含在通知中
│
└── 通知用户:
    ├── PR 链接
    ├── 预览 URL (如有)
    └── CI 状态
```

---

## 七、通信决策

```
需要和用户沟通
│
├── 什么时候发消息？
│   ├── 遇到阻塞性问题 → 立即 (block=true)
│   ├── 完成任务 → 立即 (block=true)
│   ├── 重要进度更新 → 非阻塞 (block=false)
│   ├── 需要决策输入 → 阻塞 (block=true)
│   └── 中间状态 → 不发 (继续工作)
│
├── 消息格式
│   ├── 简洁 (1-3 句)
│   ├── 包含链接（PR、文档等）
│   ├── 不用 emoji
│   ├── 不复述刚做的事
│   └── 有错误时详细说明
│
└── 特殊通信
    ├── 需要密钥 → 三选项协议
    ├── 需要选择 → user_question + options
    ├── 展示 UI → suggest_open_desktop
    └── 多个缺失信息 → 批量一次问
```

---

## 八、仓库设置决策

```
设置新仓库
│
├── 1. 信息收集
│   ├── 读 README.md
│   ├── 读 CONTRIBUTING.md (如有)
│   ├── 读 package.json / pyproject.toml / Cargo.toml
│   ├── 读 Makefile / Justfile (如有)
│   └── 检查 .nvmrc / .python-version / rust-toolchain.toml
│
├── 2. 工具选择
│   ├── README 指定 volta → 用 volta
│   ├── README 指定 nvm → 用 nvm
│   ├── README 指定 pnpm → 用 pnpm (不是 npm)
│   ├── README 指定 poetry → 用 poetry (不是 pip)
│   └── README 没指定 → 用最通用的 (npm/pip)
│
├── 3. 依赖安装
│   ├── Node.js: npm install / pnpm install / yarn
│   ├── Python: pip install / poetry install / uv sync
│   ├── Rust: cargo build
│   └── Multi-lang: 按顺序安装所有
│
├── 4. 验证
│   ├── 构建 → npm run build / cargo build
│   ├── 测试 → npm test / pytest
│   ├── Dev server → npm run dev
│   └── pre-commit → pre-commit install
│
├── 5. 问题处理
│   ├── 安装失败:
│   │   ├── 缺少系统依赖 → apt install
│   │   ├── 版本不兼容 → 按 README 指定版本
│   │   └── 仍然失败 → workaround 或问用户
│   ├── 构建失败:
│   │   ├── 缺少 env 变量 → 创建 .env.example
│   │   ├── 缺少外部服务 → docker-compose up
│   │   └── 仍然失败 → 问用户
│   └── 测试失败:
│       ├── 需要数据库 → docker-compose up + migrate
│       ├── 需要 API key → 密钥请求协议
│       └── 某些测试跳过 → 记录并告知用户
│
└── 6. 持久化
    ├── 建议蓝图 (update_environment_config)
    ├── 建议技能 (suggest_skill_pr)
    └── 记录知识 (suggest_knowledge)
```

---

## 九、密钥/认证决策

```
需要认证信息
│
├── 先检查是否已有
│   ├── list_secrets 查看已有密钥
│   ├── 检查环境变量
│   └── 检查 .env 文件 (不提交！)
│
├── 如果没有:
│   ├── 提供三选项:
│   │   ├── "跳过" → 设计绕过方案
│   │   │   ├── mock 服务
│   │   │   ├── 跳过相关测试
│   │   │   └── 使用本地替代
│   │   ├── "临时" → request_secret(should_save=false)
│   │   └── "永久" → request_secret(should_save=true)
│   │       ├── save_scope=org (共享凭据)
│   │       ├── save_scope=user (个人凭据)
│   │       └── save_scope=repo (项目特定)
│   │
│   └── 提供配置帮助:
│       ├── AWS → CLI 命令创建 IAM user
│       ├── DB → CREATE USER + GRANT 语句
│       ├── API → 链接到 key 创建页面
│       ├── OAuth → 建议创建 service account
│       └── TOTP → 说明如何从密码管理器导出
│
└── 密钥使用规则:
    ├── Shell 中: ${SECRET_NAME}
    ├── TOTP: ${_2FA_SECRET_NAME}
    ├── 绝不打印密钥值
    ├── 绝不提交到代码
    └── 绝不在日志中暴露
```

---

## 十、测试决策

```
是否需要测试？
│
├── 用户明确要求测试 → 执行
├── 用户明确要求复现 bug → 执行
├── 用户没提测试 → 跳过
│
├── 测试类型选择:
│   ├── 单元测试 → jest / pytest / cargo test
│   ├── 集成测试 → supertest / playwright
│   ├── E2E 测试 → 浏览器 + 录屏
│   └── 手动验证 → curl / 浏览器
│
├── UI 测试流程:
│   ├── 1. 录屏开始
│   ├── 2. 标注 setup (导航到页面)
│   ├── 3. 标注 test_start ("It should ...")
│   ├── 4. 执行操作
│   ├── 5. 标注 assertion (passed/failed)
│   ├── 6. 录屏结束
│   └── 7. 发送录屏给用户
│
└── 测试失败处理:
    ├── 是否是本次变更导致？
    │   ├── 是 → 修复代码
    │   ├── 否 → 检查 base branch CI
    │   └── 不确定 → 本地运行 base branch 测试
    └── 修复后重新运行
```
