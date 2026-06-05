#!/bin/bash
# =============================================================================
# Git Hooks 安装脚本
# 用法: bash git-hooks-setup.sh
# 在项目根目录运行，自动配置 Git hooks
# =============================================================================

set -e

HOOKS_DIR=".git/hooks"

if [ ! -d ".git" ]; then
    echo "错误: 不在 Git 仓库根目录"
    exit 1
fi

echo "安装 Git hooks..."

# ─────────────────────────────────────────────
# pre-commit hook
# ─────────────────────────────────────────────

cat > "$HOOKS_DIR/pre-commit" << 'HOOK'
#!/bin/bash
# Pre-commit hook — 提交前自动检查

# 检查敏感文件
SENSITIVE_PATTERNS=".env credentials.json service-account .pem id_rsa id_ed25519"
STAGED=$(git diff --cached --name-only)

for pattern in $SENSITIVE_PATTERNS; do
    if echo "$STAGED" | grep -q "$pattern"; then
        echo "错误: 检测到敏感文件: $pattern"
        echo "如果确定要提交，使用 git commit --no-verify"
        exit 1
    fi
done

# 检查 git add . 的常见错误（大量文件）
FILE_COUNT=$(echo "$STAGED" | wc -l)
if [ "$FILE_COUNT" -gt 50 ]; then
    echo "警告: 暂存了 $FILE_COUNT 个文件。"
    echo "建议使用 git add <特定文件> 而非 git add ."
    echo "继续提交请使用 git commit --no-verify"
    exit 1
fi

# 如果安装了 pre-commit，运行它
if command -v pre-commit >/dev/null 2>&1; then
    pre-commit run --files $(echo "$STAGED" | tr '\n' ' ')
fi
HOOK
chmod +x "$HOOKS_DIR/pre-commit"

# ─────────────────────────────────────────────
# commit-msg hook
# ─────────────────────────────────────────────

cat > "$HOOKS_DIR/commit-msg" << 'HOOK'
#!/bin/bash
# Commit-msg hook — 验证提交消息格式

MSG=$(cat "$1")

# Conventional commits 格式检查
PATTERN="^(feat|fix|refactor|docs|test|chore|style|perf|ci|build|revert)(\(.+\))?: .{1,}"

if ! echo "$MSG" | grep -qE "$PATTERN"; then
    # 不强制，只给出建议
    echo "提示: 建议使用 conventional commits 格式:"
    echo "  feat: 新功能"
    echo "  fix: 修复 bug"
    echo "  refactor: 重构"
    echo "  docs: 文档"
    echo "  test: 测试"
    echo "  chore: 杂项"
fi
HOOK
chmod +x "$HOOKS_DIR/commit-msg"

# ─────────────────────────────────────────────
# pre-push hook
# ─────────────────────────────────────────────

cat > "$HOOKS_DIR/pre-push" << 'HOOK'
#!/bin/bash
# Pre-push hook — 推送前检查

# 防止推送到 main/master
BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null)

if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
    echo "错误: 禁止直接推送到 $BRANCH"
    echo "请创建 feature branch 并通过 PR 合并"
    exit 1
fi
HOOK
chmod +x "$HOOKS_DIR/pre-push"

echo "Git hooks 安装完成:"
echo "  - pre-commit:  检查敏感文件 + 运行 pre-commit"
echo "  - commit-msg:  提示 conventional commits 格式"
echo "  - pre-push:    禁止推送到 main/master"
