# 常见问题排查指南

> 智能体工作中常见问题的系统化排查流程。
> 每个问题包含: 症状 → 诊断命令 → 根因分析 → 修复方案。

---

## 目录

1. [环境问题](#1-环境问题)
2. [依赖安装问题](#2-依赖安装问题)
3. [Git 问题](#3-git-问题)
4. [CI/CD 失败](#4-cicd-失败)
5. [TypeScript/JavaScript 问题](#5-typescriptjavascript-问题)
6. [Python 问题](#6-python-问题)
7. [Docker 问题](#7-docker-问题)
8. [测试问题](#8-测试问题)
9. [性能问题](#9-性能问题)
10. [密钥和认证问题](#10-密钥和认证问题)

---

## 1. 环境问题

### 1.1 Node.js 版本不匹配

**症状**: `SyntaxError: Unexpected token`、`engine` 不兼容

**诊断**:
```bash
node -v                              # 当前版本
cat .nvmrc 2>/dev/null               # 项目要求版本
cat .node-version 2>/dev/null        # 另一种指定方式
grep '"node"' package.json           # engines 字段
cat .tool-versions 2>/dev/null       # asdf 版本
```

**修复**:
```bash
# 使用 nvm
nvm install $(cat .nvmrc) && nvm use $(cat .nvmrc)

# 使用 volta
volta install node@$(cat .nvmrc)

# 使用 fnm
fnm install $(cat .nvmrc) && fnm use $(cat .nvmrc)
```

### 1.2 Python 版本不匹配

**症状**: `SyntaxError`、`ModuleNotFoundError`

**诊断**:
```bash
python3 --version
cat .python-version 2>/dev/null
grep 'python_requires' setup.py 2>/dev/null
grep 'requires-python' pyproject.toml 2>/dev/null
```

**修复**:
```bash
# 使用 pyenv
pyenv install 3.12 && pyenv local 3.12

# 使用 uv
uv python install 3.12
```

### 1.3 端口被占用

**症状**: `EADDRINUSE`、`Address already in use`

**诊断**:
```bash
lsof -i :3000                       # 查看端口占用
netstat -tlnp 2>/dev/null | grep 3000
ss -tlnp | grep 3000                # 更现代的替代
```

**修复**:
```bash
# 杀死占用进程
kill $(lsof -t -i:3000)

# 强制杀死
kill -9 $(lsof -t -i:3000)

# 或使用其他端口
PORT=3001 npm run dev
```

### 1.4 磁盘空间不足

**症状**: `ENOSPC`、`No space left on device`

**诊断**:
```bash
df -h                                # 磁盘使用
du -sh node_modules/ 2>/dev/null     # node_modules 大小
du -sh .git/ 2>/dev/null             # git 仓库大小
docker system df 2>/dev/null         # Docker 磁盘使用
```

**修复**:
```bash
# 清理 node_modules 缓存
npm cache clean --force

# 清理 Docker
docker system prune -a --volumes

# 清理 git 历史中的大文件
git gc --aggressive --prune=now
```

---

## 2. 依赖安装问题

### 2.1 npm install 失败

**症状**: `ERESOLVE`、`peer dependency conflict`

**诊断**:
```bash
npm ls 2>&1 | grep "UNMET"          # 未满足的依赖
cat package-lock.json | head -5      # 确认 lockfile 存在
npm --version                        # npm 版本
```

**修复**:
```bash
# 方案1: 清理缓存重试
rm -rf node_modules package-lock.json
npm install

# 方案2: 使用 legacy peer deps
npm install --legacy-peer-deps

# 方案3: 使用 force
npm install --force
```

### 2.2 pip install 失败

**症状**: `Could not build wheel`、`No matching distribution`

**诊断**:
```bash
pip --version
python3 -m pip install --dry-run <package>
pip install <package> -v 2>&1 | tail -20   # 详细错误
```

**修复**:
```bash
# 安装构建依赖
sudo apt-get install -y build-essential python3-dev

# 对于特定包
sudo apt-get install -y libffi-dev libssl-dev  # cryptography
sudo apt-get install -y libpq-dev              # psycopg2
sudo apt-get install -y libxml2-dev            # lxml

# 使用 uv（更快更可靠）
pip install uv && uv pip install <package>
```

### 2.3 Monorepo 依赖问题

**症状**: 子包找不到其他包的类型/模块

**诊断**:
```bash
# 检查 workspace 配置
cat pnpm-workspace.yaml 2>/dev/null
cat lerna.json 2>/dev/null
grep -A5 '"workspaces"' package.json 2>/dev/null

# 检查包之间的引用
grep -r '"workspace:' */package.json 2>/dev/null
```

**修复**:
```bash
# pnpm: 重新安装所有 workspace 依赖
pnpm install --force

# turbo: 清理并重建
turbo clean && turbo build

# lerna: bootstrap
npx lerna bootstrap
```

---

## 3. Git 问题

### 3.1 合并冲突

**症状**: `CONFLICT (content)`

**诊断**:
```bash
git status                           # 查看冲突文件
git diff --name-only --diff-filter=U # 只列出冲突文件
git log --merge --oneline            # 查看冲突的提交
```

**修复**:
```bash
# 查看冲突标记
grep -rn "<<<<<<< HEAD" .

# 接受当前分支的更改
git checkout --ours <file>

# 接受合并分支的更改
git checkout --theirs <file>

# 手动解决后
git add <file>
git commit
```

### 3.2 Shallow Clone 问题

**症状**: `fatal: shallow file has changed since we read it`、git log/blame 不完整

**诊断**:
```bash
git rev-parse --is-shallow-repository   # true = 浅克隆
git log --oneline | wc -l              # 只有很少提交
```

**修复**:
```bash
git fetch --unshallow                  # 获取完整历史
```

### 3.3 Detached HEAD

**症状**: `HEAD detached at <commit>`

**诊断**:
```bash
git status                             # 确认 detached 状态
git branch -a                          # 列出所有分支
```

**修复**:
```bash
# 创建新分支保存当前工作
git checkout -b fix/my-changes

# 或者回到之前的分支
git checkout main
```

### 3.4 Push 被拒绝

**症状**: `! [rejected]`、`non-fast-forward`

**诊断**:
```bash
git log --oneline origin/main..HEAD    # 本地比远程多的提交
git log --oneline HEAD..origin/main    # 远程比本地多的提交
```

**修复**:
```bash
# 方案1: 先拉取再推送
git pull --rebase origin main
git push origin main

# 方案2: feature branch 可以 force push
git push --force-with-lease origin feature/my-branch
```

---

## 4. CI/CD 失败

### 4.1 快速诊断流程

```
CI 失败
├── 获取失败日志
│   └── git_pr_checks → git_ci_job_logs(job_id)
├── 分类失败
│   ├── lint/format → 自动修复
│   ├── typecheck → 分析类型错误
│   ├── test → 分析测试失败
│   ├── build → 检查构建配置
│   └── security → 检查依赖漏洞
├── 判断是否自己的改动引起
│   └── 对比 base branch 的 CI 状态
└── 修复（最多 3 次）
    └── 超过 3 次 → 求助用户
```

### 4.2 常见 CI 错误速查表

| 错误关键词 | 可能原因 | 快速修复 |
|-----------|---------|---------|
| `Cannot find module` | 导入路径错误 | 检查文件路径和导出 |
| `Type 'X' is not assignable` | 类型不匹配 | 修复类型签名 |
| `Unexpected token` | 语法错误或 Node 版本 | 检查语法和 engine |
| `ENOMEM` | 内存不足 | 增加 CI runner 内存或优化构建 |
| `Timeout` | 异步未完成 | 增加超时或修复 async |
| `EACCES` | 权限问题 | 检查文件权限 |
| `not found: jest` | 依赖未安装 | 检查 devDependencies |
| `Module build failed` | Webpack/Vite 构建错误 | 检查配置和 loader |
| `ESLint: no-unused-vars` | 未使用的变量 | 删除或加 `_` 前缀 |
| `prettier: formatting` | 格式不符 | `npx prettier --write .` |

### 4.3 Lint/Format 自动修复

```bash
# ESLint
npx eslint . --fix

# Prettier
npx prettier --write .

# Ruff (Python)
ruff check --fix . && ruff format .

# Clippy (Rust)
cargo clippy --fix --allow-dirty

# 提交修复
git add -u && git commit -m "fix: auto-fix lint issues"
```

---

## 5. TypeScript/JavaScript 问题

### 5.1 类型错误

**症状**: `TS2322`、`TS2339`、`TS2345`

**诊断**:
```bash
npx tsc --noEmit                     # 完整类型检查
npx tsc --noEmit 2>&1 | head -30    # 看前 30 行错误
```

**常见修复模式**:
```typescript
// TS2322: Type 'string | undefined' is not assignable to type 'string'
// 修复: 添加非空断言或默认值
const name = user.name ?? 'default';

// TS2339: Property 'x' does not exist on type 'Y'
// 修复: 检查类型定义是否正确
if ('x' in obj) { /* now TypeScript knows obj has x */ }

// TS2345: Argument of type 'X' is not assignable to parameter of type 'Y'
// 修复: 检查函数签名是否匹配
```

### 5.2 Module Resolution 问题

**症状**: `Cannot find module`、`Module not found`

**诊断**:
```bash
# 检查 tsconfig 的 paths 配置
cat tsconfig.json | grep -A10 '"paths"'

# 检查文件是否存在
find . -name "目标模块名*" -not -path "*/node_modules/*"
```

**修复**: 检查 `tsconfig.json` 的 `paths`、`baseUrl`、`moduleResolution` 配置。

---

## 6. Python 问题

### 6.1 Import 错误

**症状**: `ModuleNotFoundError`、`ImportError`

**诊断**:
```bash
python3 -c "import sys; print(sys.path)"   # Python 搜索路径
pip list | grep <package>                   # 检查包是否安装
pip show <package>                          # 包的详细信息
```

**修复**:
```bash
# 安装缺失的包
pip install <package>

# 如果是本地包
pip install -e .

# 如果是虚拟环境问题
source .venv/bin/activate    # 确保激活了虚拟环境
```

### 6.2 虚拟环境问题

**诊断**:
```bash
which python3                           # 确认使用的 Python
echo $VIRTUAL_ENV                       # 当前虚拟环境
ls .venv/ 2>/dev/null || ls venv/ 2>/dev/null
```

**修复**:
```bash
# 重建虚拟环境
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

---

## 7. Docker 问题

### 7.1 容器启动失败

**诊断**:
```bash
docker compose logs --tail=50          # 最近的日志
docker compose ps                      # 容器状态
docker inspect <container_id>          # 详细信息
```

**修复**:
```bash
# 重建容器
docker compose down && docker compose up -d --build

# 清理悬挂的镜像
docker image prune -f

# 完全重置
docker compose down -v && docker compose up -d
```

### 7.2 网络问题

**症状**: 容器间无法通信

**诊断**:
```bash
docker network ls                      # 列出网络
docker network inspect <network>       # 网络详情
docker compose exec <service> ping <other_service>
```

---

## 8. 测试问题

### 8.1 测试超时

**诊断**:
```bash
# 单独运行慢测试
npm test -- --testPathPattern="慢测试名" --verbose

# 增加超时
jest --testTimeout=30000
pytest --timeout=60
```

### 8.2 快照测试失败

**修复**:
```bash
# 更新快照 (确认变更是预期的)
npm test -- -u

# 只更新特定测试
npm test -- -u --testPathPattern="组件名"
```

### 8.3 测试间状态污染

**症状**: 单独跑通过，一起跑失败

**诊断**:
```bash
# 随机顺序运行
jest --randomize

# 只运行失败的测试
jest --onlyFailures

# 打印测试名称和时间
jest --verbose --showConfig
```

---

## 9. 性能问题

### 9.1 构建太慢

**诊断**:
```bash
# 检查 node_modules 大小
du -sh node_modules/

# 分析 webpack bundle
npx webpack-bundle-analyzer
```

**优化**:
```bash
# 使用 SWC 替代 Babel
npm install @swc/core @swc/jest -D

# 使用增量编译
npx tsc --incremental

# 使用 Turbopack (Next.js)
next dev --turbo
```

### 9.2 测试太慢

**优化**:
```bash
# 并行运行
jest --maxWorkers=50%

# 使用 Vitest (更快的测试框架)
npx vitest run

# 只运行受影响的测试
jest --onlyChanged
```

---

## 10. 密钥和认证问题

### 10.1 GitHub 认证失败

**症状**: `remote: Permission denied`、`403 Forbidden`

**诊断**:
```bash
git remote -v                          # 检查远程 URL
git config user.name                   # 检查用户配置
ssh -T git@github.com 2>&1            # SSH 连接测试 (如果用 SSH)
```

**修复**: 检查 PAT token 权限，确保有 `repo` scope。

### 10.2 API 密钥无效

**症状**: `401 Unauthorized`、`403 Forbidden`

**排查清单**:
```
1. 密钥是否过期？ → 重新生成
2. 密钥权限是否足够？ → 检查 scope
3. 是否用了正确的环境？ → 检查 staging vs production
4. 环境变量是否正确加载？ → echo $API_KEY (只看前几位)
5. 是否有多余的空格/换行？ → echo -n "$API_KEY" | xxd | tail
```

### 10.3 环境变量未加载

**诊断**:
```bash
# 检查 .env 文件
cat .env | head -5

# 检查环境变量是否存在
env | grep API_KEY

# 检查加载顺序
# .env.local > .env.development > .env
```

**修复**:
```bash
# 手动加载
source .env

# 或使用 dotenv
npx dotenv -- node script.js

# Python
pip install python-dotenv
```

---

## 通用排查流程

当遇到未列出的问题时，按以下流程排查:

```
1. 读取完整错误消息（不要只看第一行）
2. 搜索错误关键词
   ├── 在项目中搜索: grep -r "关键词" .
   ├── 在文档中搜索: README.md, CONTRIBUTING.md
   └── 在网络搜索: 错误消息 + 技术栈
3. 检查最近的变更
   ├── git diff HEAD~3 --stat
   └── git log --oneline -5
4. 检查环境差异
   ├── 本地 vs CI 的 Node/Python/OS 版本
   └── 依赖版本是否一致 (lockfile)
5. 最小化复现
   ├── 创建最小测试用例
   └── 二分法定位 (git bisect)
6. 如果 3 次尝试未解决 → 求助用户
```
