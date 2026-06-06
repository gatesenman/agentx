# 自动化与 Hooks 完整参考

> 自动化系统让智能体能够响应外部事件（PR 创建、CI 失败、Issue 打开等）
> 自动触发预定义的行为，无需人工干预。

---

## 一、事件驱动自动化

### PR 审查自动化
```yaml
名称: pr-auto-review
触发器: PR 创建 或 PR 更新（新 push）
行为:
  1. 获取 PR diff
  2. 分析代码变更:
     - 检查编码规范违反
     - 检查潜在 bug（空指针、未处理异常）
     - 检查安全问题（密钥泄露、SQL注入）
     - 检查测试覆盖（新代码是否有测试）
     - 检查性能影响（N+1 查询、大循环）
  3. 发表审查评论
  4. 如有严重问题，标记为 "Changes Requested"

配置示例:
  trigger: "pr_created, pr_updated"
  repos: ["owner/repo1", "owner/repo2"]
  prompt: |
    审查此 PR:
    - 重点检查安全性和正确性
    - 忽略格式问题（交给 linter）
    - 评论要具体，给出修复建议
    - 小问题用 "nit:" 前缀
```

### Issue 分诊自动化
```yaml
名称: issue-triage
触发器: Issue 创建
行为:
  1. 分析 Issue 内容
  2. 判断类型（bug/feature/question/docs）
  3. 评估优先级（critical/high/medium/low）
  4. 添加标签
  5. 指派给相关人员
  6. 如果是 bug 且有足够信息，尝试定位代码

配置示例:
  trigger: "issue_created"
  prompt: |
    分析此 Issue:
    1. 判断类型并加标签: bug, feature, question, docs
    2. 评估优先级: P0(生产故障) P1(严重) P2(普通) P3(低)
    3. 根据涉及的代码区域指派 reviewer
    4. 如果是 bug，尝试在代码中定位可能的问题位置
```

### CI 失败自动修复
```yaml
名称: ci-auto-fix
触发器: CI 检查失败
行为:
  1. 获取失败日志
  2. 分析失败原因:
     - lint 错误 → 自动修复并推送
     - 类型错误 → 尝试修复并推送
     - 测试失败 → 分析是否是本次变更导致
     - 构建失败 → 检查依赖问题
  3. 如果可自动修复 → 推送修复 commit
  4. 如果不能自动修复 → 评论说明原因

配置示例:
  trigger: "ci_failed"
  prompt: |
    CI 失败了，请:
    1. 查看失败日志
    2. 如果是 lint/format 问题，直接修复
    3. 如果是类型错误，尝试修复
    4. 如果是测试失败，分析根因
    5. 最多尝试 3 次修复
```

### 依赖更新自动化
```yaml
名称: dependency-update
触发器: 定时（每周一）或 Dependabot PR
行为:
  1. 检查过时的依赖
  2. 评估更新风险（major/minor/patch）
  3. 创建更新 PR
  4. 运行测试验证兼容性
  5. 如果测试通过，标记为可合并
```

---

## 二、定时调度 (Schedules)

### 每日代码扫描
```yaml
名称: daily-security-scan
调度: "0 9 * * 1-5"  # 工作日 9:00
行为:
  1. 运行依赖漏洞扫描
  2. 检查密钥泄露
  3. 生成报告
  4. 如有问题，创建 Issue
```

### 每周报告
```yaml
名称: weekly-report
调度: "0 17 * * 5"  # 每周五 17:00
行为:
  1. 收集本周 PR 合并记录
  2. 收集 CI 失败统计
  3. 收集代码覆盖率变化
  4. 生成周报并发送
```

---

## 三、Git Hooks（本地）

### pre-commit Hook
```bash
#!/bin/bash
# .git/hooks/pre-commit
# 提交前自动运行检查

set -e

echo "🔍 Running pre-commit checks..."

# 1. 检查是否有密钥泄露
SECRETS_FOUND=$(grep -rn "AKIA\|sk-\|ghp_\|gho_\|password\s*=\s*['\"]" \
  --include="*.ts" --include="*.py" --include="*.js" --include="*.env" \
  $(git diff --cached --name-only) 2>/dev/null || true)

if [ -n "$SECRETS_FOUND" ]; then
  echo "❌ 可能的密钥泄露:"
  echo "$SECRETS_FOUND"
  echo ""
  echo "如果是误报，使用 git commit --no-verify 跳过"
  exit 1
fi

# 2. 运行 linter (仅对 staged 文件)
STAGED_TS=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(ts|tsx)$' || true)
STAGED_PY=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.py$' || true)

if [ -n "$STAGED_TS" ]; then
  echo "  TypeScript lint..."
  npx eslint $STAGED_TS --quiet 2>/dev/null || {
    echo "❌ ESLint 失败。运行 'npx eslint --fix' 修复"
    exit 1
  }
fi

if [ -n "$STAGED_PY" ]; then
  echo "  Python lint..."
  ruff check $STAGED_PY 2>/dev/null || {
    echo "❌ Ruff 失败。运行 'ruff check --fix' 修复"
    exit 1
  }
fi

# 3. 运行 typecheck
if [ -f "tsconfig.json" ] && [ -n "$STAGED_TS" ]; then
  echo "  TypeScript typecheck..."
  npx tsc --noEmit --incremental 2>/dev/null || {
    echo "❌ TypeScript 类型检查失败"
    exit 1
  }
fi

echo "✅ All pre-commit checks passed"
```

### commit-msg Hook
```bash
#!/bin/bash
# .git/hooks/commit-msg
# 验证 commit message 格式

COMMIT_MSG_FILE=$1
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# Conventional Commits 格式验证
PATTERN="^(feat|fix|chore|refactor|docs|test|style|perf|ci|build|revert)(\(.+\))?: .{1,72}$"

# 检查第一行
FIRST_LINE=$(head -n 1 "$COMMIT_MSG_FILE")

if ! echo "$FIRST_LINE" | grep -qE "$PATTERN"; then
  echo "❌ Commit message 不符合 Conventional Commits 规范"
  echo ""
  echo "格式: <type>(<scope>): <description>"
  echo ""
  echo "type 必须是: feat|fix|chore|refactor|docs|test|style|perf|ci|build|revert"
  echo "description 不超过 72 字符"
  echo ""
  echo "示例:"
  echo "  feat(auth): 添加 OAuth2 登录支持"
  echo "  fix: 修复用户列表分页问题"
  echo "  chore: 更新依赖版本"
  echo ""
  echo "你的消息: $FIRST_LINE"
  exit 1
fi

echo "✅ Commit message format OK"
```

### pre-push Hook
```bash
#!/bin/bash
# .git/hooks/pre-push
# 推送前运行测试

BRANCH=$(git rev-parse --abbrev-ref HEAD)

# 跳过 main/master 的直接推送检查（不应该发生）
if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
  echo "⚠️  警告: 不应该直接推送到 $BRANCH"
  echo "请使用 feature branch + PR 流程"
  exit 1
fi

echo "🧪 Running tests before push..."

# 运行快速测试
if [ -f "package.json" ]; then
  npm test -- --bail --watchAll=false 2>/dev/null || {
    echo "❌ 测试失败，推送已阻止"
    exit 1
  }
elif [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
  pytest tests/ --tb=short -q 2>/dev/null || {
    echo "❌ 测试失败，推送已阻止"
    exit 1
  }
elif [ -f "Cargo.toml" ]; then
  cargo test --quiet 2>/dev/null || {
    echo "❌ 测试失败，推送已阻止"
    exit 1
  }
fi

echo "✅ Tests passed, pushing..."
```

### Git Hooks 安装脚本
```bash
#!/bin/bash
# hooks/install-hooks.sh
# 一键安装所有 git hooks

HOOKS_DIR=".git/hooks"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing git hooks..."

# 安装 pre-commit
cp "$SCRIPT_DIR/../hooks/pre-commit" "$HOOKS_DIR/pre-commit"
chmod +x "$HOOKS_DIR/pre-commit"
echo "  ✓ pre-commit"

# 安装 commit-msg
cp "$SCRIPT_DIR/../hooks/commit-msg" "$HOOKS_DIR/commit-msg"
chmod +x "$HOOKS_DIR/commit-msg"
echo "  ✓ commit-msg"

# 安装 pre-push
cp "$SCRIPT_DIR/../hooks/pre-push" "$HOOKS_DIR/pre-push"
chmod +x "$HOOKS_DIR/pre-push"
echo "  ✓ pre-push"

echo ""
echo "Done! All hooks installed."
echo "To skip hooks: git commit --no-verify (不推荐)"
```

---

## 四、自动化触发条件矩阵

| 事件 | 触发器名称 | 典型行为 |
|------|-----------|---------|
| PR 创建 | `pr_created` | 代码审查、标签添加 |
| PR 更新 | `pr_updated` | 重新审查变更部分 |
| PR 合并 | `pr_merged` | 部署、通知、清理分支 |
| Issue 创建 | `issue_created` | 分诊、标签、指派 |
| CI 失败 | `ci_failed` | 自动修复尝试 |
| 定时 | `cron` | 扫描、报告、清理 |
| 评论 | `comment_created` | 响应命令 (如 /deploy) |
| 标签变更 | `label_added` | 触发对应流程 |
| 分支推送 | `push` | 自动测试、部署预览 |

---

## 五、自动化配置最佳实践

### 应该自动化
- PR 代码审查（减少人工负担）
- lint/format 修复（纯机械性）
- 依赖更新（routine task）
- Issue 分诊（减少响应时间）
- 安全扫描（不应遗忘）

### 不应该自动化
- 架构决策
- 生产部署（需要人工确认）
- 删除操作
- 任何不可逆的破坏性操作

### 自动化测试
- 先在测试仓库验证
- 设置失败通知
- 定期检查自动化是否仍有效
- 记录每次自动化执行的结果
