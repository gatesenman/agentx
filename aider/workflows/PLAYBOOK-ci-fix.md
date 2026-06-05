# CI 修复工作流

## 触发条件
PR 上的 CI 检查失败（lint、类型、测试、构建、依赖）。

## 完整步骤

### 第1步: 检查 CI 状态
```bash
# 查看哪些检查失败
# 工具: git_pr_checks 或
gh pr checks <PR号>

# 记录:
# - 失败的检查名称
# - 失败的 job ID
# - 失败时间
```

### 第2步: 获取失败日志
```bash
# 获取详细日志
# 工具: git_ci_job_logs(job_id=失败的job_id)
# 或
gh run view <run_id> --log-failed

# 关键信息提取:
# - 精确的错误消息
# - 失败的文件和行号
# - 调用栈（如有）
```

### 第3步: 分类失败

#### 类型A: Lint/格式错误
```bash
# 本地复现
npm run lint
# 或
ruff check .
# 或
eslint src/

# 自动修复
npm run lint -- --fix
# 或
ruff check . --fix
# 或
prettier --write src/改的文件.ts
```

#### 类型B: 类型错误
```bash
# 本地复现
npm run typecheck
# 或
mypy src/
# 或
pyright

# 修复原则:
# - 正确定义类型，永不用 any 逃避
# - 检查函数签名、返回类型、参数类型
# - 检查 null/undefined 处理
# - 检查泛型参数
```

#### 类型C: 测试失败
```bash
# 运行失败的测试
npm test -- --grep "失败测试名" --verbose
# 或
pytest tests/test_file.py::test_name -v

# 调试:
# - 阅读测试代码理解预期行为
# - 检查测试数据/fixture 是否正确
# - 对比实际输出和预期输出
# - 永不修改测试让它通过
# - 修复被测代码的实际问题
```

#### 类型D: 构建错误
```bash
# 本地复现
npm run build
# 或
cargo build
# 或
go build ./...

# 常见原因:
# - import/export 不匹配
# - 缺失的文件引用
# - 环境变量缺失
# - 依赖版本冲突
```

#### 类型E: 依赖问题
```bash
# 检查 lockfile 是否需要更新
npm install  # 生成/更新 package-lock.json
# 或
pip install -r requirements.txt

# 版本冲突
npm ls 冲突的包名
npm why 冲突的包名
```

### 第4步: 检查是否是预存问题
```bash
# 方法1: 检查 base 分支 CI
# 查看 main/master 的最近 CI 运行是否也失败

# 方法2: 本地验证
git stash
git checkout main
npm test -- --grep "失败测试名"
# 如果 main 上也失败 → 预存在问题
# 如果 main 上通过 → 你的代码引入的

git checkout -  # 回到你的分支
git stash pop

# 重要: 没有证据永不声称是预存在或 flaky
```

### 第5步: 修复并推送
```bash
# 修复问题后:

# 暂存改动
git add src/修复的文件.ts

# 提交
git commit -m "fix: 解决 CI 失败 - 具体描述

- 修复了什么问题
- 根因是什么"

# 推送
git push
```

### 第6步: 等待 CI 并验证
```bash
# 等待新的 CI 运行完成
# 工具: git_pr_checks(wait_mode="all")

# 如果仍然失败:
#   → 回到第2步，重新分析
#   → 最多重复 3 次

# 3 次失败后:
#   → 上报用户，说明:
#     - 尝试了什么
#     - 目前的错误是什么
#     - 需要什么帮助
```

## 重要规则
```
必须遵守:
  ✓ 最多 3 次修复尝试，之后求助用户
  ✓ 修复根因，不是症状
  ✓ 每次修复都运行本地验证再推送

禁止:
  ✗ 无证据声称是 flaky 测试
  ✗ 无证据声称是预存在问题
  ✗ 跳过或禁用失败的测试
  ✗ 用 any 或 @ts-ignore 绕过类型错误
  ✗ 用 eslint-disable 绕过 lint 错误（除非有充分理由）
```

## CI 失败快速参考
```
错误类型          → 修复命令
─────────────────────────────────────
ESLint 错误       → npm run lint -- --fix
Prettier 格式     → npx prettier --write <文件>
TypeScript 类型   → 手动修复类型定义
Jest 测试失败     → 调试被测代码（不改测试）
Python lint       → ruff check . --fix
Python 类型       → 手动修复类型注解
构建失败          → 检查 import/export
依赖缺失          → npm install / pip install
```
