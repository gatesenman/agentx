# 端到端工具链编排参考

> 30+ 真实场景的完整工具链调用序列。
> 每个场景包含: 触发条件 → 工具调用顺序 → 决策分支 → 预期输出。

---

## 目录

1. [Bug 修复工具链](#1-bug-修复工具链)
2. [功能实现工具链](#2-功能实现工具链)
3. [PR 创建工具链](#3-pr-创建工具链)
4. [CI 修复工具链](#4-ci-修复工具链)
5. [仓库设置工具链](#5-仓库设置工具链)
6. [代码审查工具链](#6-代码审查工具链)
7. [重构工具链](#7-重构工具链)
8. [测试工具链](#8-测试工具链)
9. [部署工具链](#9-部署工具链)
10. [知识管理工具链](#10-知识管理工具链)
11. [调试工具链](#11-调试工具链)
12. [文档工具链](#12-文档工具链)

---

## 1. Bug 修复工具链

### 场景 1.1: 用户报告 UI Bug

```
触发: "登录按钮点了没反应"

工具链:
1. grep("onClick.*login", path="src/", glob="*.tsx")
   → 定位登录按钮组件

2. read(file_path="src/pages/Login.tsx")
   → 阅读组件代码

3. grep("handleLogin|submitLogin|onLogin", path="src/")
   → 找到处理函数

4. read(file_path="src/services/auth.ts")
   → 阅读认证服务

5. [诊断] 发现: handleLogin 里 await 缺失导致 Promise 未处理

6. edit(file_path="src/pages/Login.tsx",
        old_string="handleLogin()",
        new_string="await handleLogin()")

7. exec(command="npm run lint -- --quiet")
   → 验证无 lint 错误

8. exec(command="npm run typecheck")
   → 验证类型正确

9. exec(command="npm test -- --testPathPattern=Login --bail")
   → 运行相关测试

10. [创建 PR → 场景 3.1]
```

### 场景 1.2: 运行时错误 (Stack Trace)

```
触发: 用户提供错误堆栈

工具链:
1. [解析堆栈] 提取文件名和行号

2. read(file_path="<错误文件>", offset=<行号-10>, limit=30)
   → 查看出错位置上下文

3. grep("调用函数名", path="src/")
   → 查找所有调用点

4. [分析根因]
   ├── null/undefined → 添加空值检查
   ├── 类型错误 → 修复类型转换
   └── 异步问题 → 添加 error handling

5. edit(...) → 修复

6. exec("npm test -- --bail") → 验证
```

### 场景 1.3: 回归 Bug (Git Bisect)

```
触发: "这个功能上周还好使的"

工具链:
1. git rev-parse --is-shallow-repository
   ├── true → exec("git fetch --unshallow")
   └── false → 继续

2. exec("git log --oneline --since='2 weeks ago' -- src/相关目录/")
   → 查看最近的提交

3. exec("git bisect start")
4. exec("git bisect bad HEAD")
5. exec("git bisect good <2周前的commit>")
6. exec("git bisect run npm test -- --testPathPattern=相关测试")
   → 自动定位引入 bug 的提交

7. exec("git bisect reset")

8. exec("git show <bad-commit>")
   → 查看引入 bug 的变更

9. [基于变更修复]
```

---

## 2. 功能实现工具链

### 场景 2.1: 添加 API 端点

```
触发: "添加用户头像上传功能"

工具链:
1. [理解现有结构]
   grep("router\.|app\.", path="src/", glob="*.ts")
   find_file_by_name(pattern="**/route*.ts", path="src/")
   → 了解路由组织方式

2. read("src/routes/user.ts")
   → 了解现有的路由模式

3. grep("upload|multer|formidable", path=".", glob="package.json")
   → 检查是否已有上传库

4. [如果没有上传库]
   exec("npm install multer @types/multer")

5. [实现]
   edit("src/types/user.ts", ...)        # 添加类型
   edit("src/services/user.ts", ...)     # 添加业务逻辑
   edit("src/routes/user.ts", ...)       # 添加路由
   edit("src/middleware/upload.ts", ...) # 添加中间件

6. [验证]
   exec("npm run lint")
   exec("npm run typecheck")
   exec("npm test")
```

### 场景 2.2: 添加前端页面

```
触发: "添加用户设置页面"

工具链:
1. [理解项目结构]
   find_file_by_name(pattern="**/pages/**/*.tsx", path="src/")
   → 了解页面组织

2. read("src/pages/Dashboard.tsx")
   → 参考现有页面的写法

3. grep("useRouter|Link|navigate", path="src/pages/", glob="*.tsx")
   → 了解路由使用方式

4. [查看 UI 组件库]
   find_file_by_name(pattern="**/components/ui/*.tsx", path="src/")
   → 了解可用的 UI 组件

5. [创建页面]
   write("src/pages/Settings.tsx", ...)

6. [注册路由]
   edit("src/App.tsx", ...)  或  edit("src/routes/index.tsx", ...)

7. [验证]
   exec("npm run lint")
   exec("npm run typecheck")
   exec("npm run build")
```

---

## 3. PR 创建工具链

### 场景 3.1: 标准 PR 创建

```
工具链:
1. exec("git checkout -b devin/$(date +%s)-fix-login-bug")

2. exec("git add -u")
   # 注意: 不要 git add .

3. exec('git diff --cached --stat')
   → 确认只添加了相关文件

4. exec('git commit -m "fix(auth): 修复登录按钮点击无响应的问题"')

5. exec("git push origin <branch-name>")

6. fetch_pr_template(repo="github.com/owner/repo")

7. git_create_pr(
     repo="github.com/owner/repo",
     title="fix(auth): 修复登录按钮点击无响应",
     head_branch="devin/...",
     base_branch="main",
     body="## Summary\n...",
     draft=false
   )

8. git_pr_checks(repo="...", pull_number=N, wait_mode="all")
   ├── 全部通过 → 通知用户
   └── 有失败 → 场景 4.1
```

### 场景 3.2: 带截图的前端 PR

```
在场景 3.1 基础上增加:

4.5. [启动 dev server]
     exec("npm run dev", run_in_background=true, shell_id="dev")

4.6. [等待启动]
     get_output(shell_id="dev", timeout=10000)

4.7. [截图]
     computer(actions=[
       {action: "key", text: "ctrl+l"},
       {action: "type", text: "http://localhost:3000/login"},
       {action: "key", text: "Return"}
     ])
     computer(actions=[{action: "screenshot"}])

4.8. [PR body 中包含截图路径]
     body="![登录页面](/tmp/screenshot.png)"
```

---

## 4. CI 修复工具链

### 场景 4.1: CI 失败自动修复

```
触发: PR checks 失败

工具链:
1. git_pr_checks(repo="...", pull_number=N, wait_mode="none")
   → 获取失败的 job

2. git_ci_job_logs(repo="...", job_id=<failed_job_id>)
   → 获取日志

3. [分类]
   ├── lint 错误:
   │   exec("npx eslint . --fix")
   │   exec("npx prettier --write .")
   │
   ├── typecheck 错误:
   │   read(<错误文件>)
   │   edit(...) → 修复类型
   │
   ├── 测试失败:
   │   exec("npm test -- --testPathPattern=<失败测试> --verbose")
   │   read(<测试文件>)
   │   [分析失败原因并修复]
   │
   └── 构建失败:
       exec("npm run build 2>&1 | tail -30")
       [修复构建错误]

4. exec("git add -u")
5. exec('git commit -m "fix: 修复 CI 失败"')
6. exec("git push origin <branch>")

7. git_pr_checks(repo="...", pull_number=N, wait_mode="all")
   ├── 通过 → 完成
   └── 失败 → 重复（最多 3 次），然后求助用户
```

### 场景 4.2: 判断是否预存问题

```
工具链:
1. [在 base branch 检查]
   exec("git stash")
   exec("git checkout main")
   exec("npm test -- --testPathPattern=<失败测试>")
   ├── 也失败 → 预存问题，告知用户
   └── 通过 → 是自己的改动引起的
   exec("git checkout <feature-branch>")
   exec("git stash pop")
```

---

## 5. 仓库设置工具链

### 场景 5.1: Node.js 项目设置

```
触发: "帮我设置这个项目"

工具链:
1. read("README.md")
   → 阅读设置指南

2. read("package.json")
   → 检查 engines, scripts, dependencies

3. [检测包管理器]
   find_file_by_name(pattern="pnpm-lock.yaml")
   find_file_by_name(pattern="yarn.lock")
   find_file_by_name(pattern="bun.lockb")

4. [检测版本管理]
   read(".nvmrc") 或 read(".node-version") 或 read(".tool-versions")

5. [安装依赖]
   exec("pnpm install")  # 或 npm/yarn/bun

6. [检查 .env]
   find_file_by_name(pattern=".env.example")
   ├── 存在 → exec("cp .env.example .env")
   └── 不存在 → 跳过

7. [安装 hooks]
   find_file_by_name(pattern=".pre-commit-config.yaml")
   ├── 存在 → exec("pre-commit install")
   └── 检查 husky → exec("npx husky install")

8. [验证]
   exec("npm run build")
   exec("npm run lint")
   exec("npm test -- --passWithNoTests --watchAll=false")

9. [启动 dev server]
   exec("npm run dev", run_in_background=true)
   → 检查是否成功启动
```

### 场景 5.2: Python 项目设置

```
工具链:
1. read("README.md")
2. read("pyproject.toml") 或 read("requirements.txt")

3. [检测工具链]
   ├── pyproject.toml + [tool.poetry] → poetry install
   ├── pyproject.toml + [tool.uv] → uv sync
   ├── Pipfile → pipenv install --dev
   └── requirements.txt → pip install -r requirements.txt

4. [创建虚拟环境]
   exec("python3 -m venv .venv")
   exec("source .venv/bin/activate")

5. [安装依赖]
   exec("pip install -e '.[dev]'")

6. [验证]
   exec("ruff check .")
   exec("mypy .")
   exec("pytest")
```

---

## 6. 代码审查工具链

### 场景 6.1: 响应 PR 评论

```
触发: 收到 reviewer 评论

工具链:
1. git_view_pr(repo="...", pull_number=N)
   → 阅读评论

2. [对每条评论]
   ├── 代码修改请求:
   │   read(<文件>)
   │   edit(...) → 修改
   │   git_comment_on_pr(in_reply_to=<comment_id>, body="已修复")
   │
   ├── 问题/疑问:
   │   git_comment_on_pr(in_reply_to=<comment_id>, body="解释...")
   │
   └── 建议:
       [评估是否采纳]
       git_comment_on_pr(in_reply_to=<comment_id>, body="采纳/不采纳及原因")

3. exec("git add -u && git commit -m 'fix: address review feedback'")
4. exec("git push")
5. git_pr_checks(wait_mode="all")
```

---

## 7. 重构工具链

### 场景 7.1: 安全重命名

```
触发: "把 UserService 改名为 AccountService"

工具链:
1. grep("UserService", path="src/", output_mode="files_with_matches")
   → 找到所有引用

2. [安全网]
   exec("npm test -- --bail --watchAll=false")
   → 确认测试基线通过

3. [重命名文件]
   exec("git mv src/services/UserService.ts src/services/AccountService.ts")

4. [更新所有引用]
   对每个文件:
   edit(file_path=<file>,
        old_string="UserService",
        new_string="AccountService",
        replace_all=true)

5. [验证每步]
   exec("npx tsc --noEmit")
   exec("npm test -- --bail")

6. exec("git add -u")
7. exec('git commit -m "refactor: rename UserService to AccountService"')
```

---

## 8. 测试工具链

### 场景 8.1: 录屏测试

```
触发: 用户要求测试 UI

工具链:
1. exec("sudo apt-get install -y wmctrl 2>/dev/null; wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz")
   → 最大化浏览器

2. recording_start()

3. annotate_recording(type="setup", description="启动开发服务器")
4. exec("npm run dev", run_in_background=true, shell_id="dev")

5. computer(actions=[{action: "key", text: "ctrl+l"},
                      {action: "type", text: "http://localhost:3000"},
                      {action: "key", text: "Return"}])

6. annotate_recording(type="test_start", test="It should render home page")

7. computer(actions=[{action: "screenshot"}])
   → 检查页面是否正确渲染

8. annotate_recording(type="assertion",
                       test="It should render home page",
                       test_result="passed",
                       assertion="Home page rendered with nav and content")

9. [更多测试步骤...]

10. recording_stop(title="UI 测试", summary="所有测试通过...")
```

---

## 9. 部署工具链

### 场景 9.1: 前端部署

```
工具链:
1. exec("npm run build")
   → 构建生产版本

2. deploy(command="frontend", dir="/path/to/dist")
   → 部署到 CDN

3. [验证部署]
   computer(actions=[
     {action: "key", text: "ctrl+l"},
     {action: "type", text: "<deployed-url>"},
     {action: "key", text: "Return"}
   ])
   computer(actions=[{action: "screenshot"}])
```

---

## 10. 知识管理工具链

### 场景 10.1: 保存项目知识

```
触发: 发现项目特定的工作方式

工具链:
1. suggest_knowledge(
     action="create",
     value="在此仓库中运行测试前需要先启动 Docker:\n  docker-compose up -d\n等待 10 秒后再运行 pytest",
     trigger="在 myapp 仓库中运行测试时"
   )
```

### 场景 10.2: 查看已有知识

```
工具链:
1. list_knowledge_notes()
   → 查看所有知识条目

2. get_knowledge_note(knowledge_id="note-abc123")
   → 获取特定条目的完整内容
```

---

## 11. 调试工具链

### 场景 11.1: 运行时调试

```
工具链:
1. [添加日志]
   edit("src/services/user.ts", ...)
   → 在关键点添加 console.log

2. [运行]
   exec("npm run dev", run_in_background=true, shell_id="dev")

3. [触发问题]
   computer(...) 或 exec("curl http://localhost:3000/api/users")

4. [查看输出]
   get_output(shell_id="dev")
   → 分析日志

5. [定位后移除日志]
   edit(...) → 移除 console.log

6. [修复]
   edit(...) → 实际修复
```

### 场景 11.2: 内存泄漏调试

```
工具链:
1. exec("node --inspect src/server.ts", run_in_background=true)

2. [压力测试]
   exec("for i in $(seq 1 100); do curl localhost:3000/api/users; done")

3. [检查内存]
   exec("ps aux | grep node")
   → 观察 RSS 增长

4. [分析]
   grep("addEventListener|setInterval|new Map|new Set", path="src/")
   → 找到可能的泄漏点
```

---

## 12. 文档工具链

### 场景 12.1: 生成 API 文档

```
工具链:
1. find_file_by_name(pattern="**/routes/**/*.ts", path="src/")
   → 找到所有路由文件

2. [对每个路由文件]
   read(<file>)
   → 提取端点、方法、参数

3. write("docs/API.md", content=<生成的文档>)

4. exec("git add docs/API.md")
5. exec('git commit -m "docs: generate API documentation"')
```

---

## 工具链编排原则

### 并行化
独立的工具调用应该并行执行:
```
✅ 并行: 同时读取 3 个文件
   read("file1") | read("file2") | read("file3")

✅ 并行: 同时搜索不同模式
   grep("pattern1") | grep("pattern2")

❌ 串行: 需要前一步结果
   read("file") → 基于内容 edit("file")
```

### 故障恢复
每个工具链都有失败回退:
```
尝试 → 失败 → 替代方案 → 仍然失败 → 求助用户

示例:
npm install → 失败
→ npm install --legacy-peer-deps → 失败
→ 删除 lockfile 重试 → 失败
→ 通知用户
```

### 验证点
关键步骤后必须验证:
```
1. 安装依赖 → 验证: 命令退出码 0
2. 代码修改 → 验证: lint + typecheck
3. 提交代码 → 验证: 测试通过
4. 推送代码 → 验证: CI 通过
5. 部署 → 验证: 访问 URL 正常
```
