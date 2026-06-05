#!/bin/bash
# =============================================================================
# 提交前检查脚本 — 在提交代码前运行所有必要检查
# 用法: bash pre-commit-check.sh
# =============================================================================

set -e

echo "========================================="
echo "  提交前检查"
echo "========================================="

ERRORS=0

# ─────────────────────────────────────────────
# 检查暂存的文件
# ─────────────────────────────────────────────

STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)
if [ -z "$STAGED_FILES" ]; then
    echo "没有暂存的文件，跳过检查"
    exit 0
fi

echo "暂存的文件:"
echo "$STAGED_FILES" | while read f; do echo "  $f"; done
echo ""

# ─────────────────────────────────────────────
# 检查密钥泄露
# ─────────────────────────────────────────────

echo "--- 检查密钥泄露 ---"
SECRETS_PATTERN='(password|secret|api_key|apikey|token|private_key|credentials)\s*[=:]\s*["\x27][^"\x27]{8,}'
LEAKED=$(echo "$STAGED_FILES" | xargs grep -ilE "$SECRETS_PATTERN" 2>/dev/null || true)
if [ -n "$LEAKED" ]; then
    echo "警告: 以下文件可能包含密钥:"
    echo "$LEAKED"
    ERRORS=$((ERRORS + 1))
fi

# 检查敏感文件
SENSITIVE_FILES=".env .env.local .env.production credentials.json service-account.json id_rsa id_ed25519"
for f in $SENSITIVE_FILES; do
    if echo "$STAGED_FILES" | grep -q "$f"; then
        echo "警告: 尝试提交敏感文件: $f"
        ERRORS=$((ERRORS + 1))
    fi
done
echo ""

# ─────────────────────────────────────────────
# Lint 检查
# ─────────────────────────────────────────────

echo "--- Lint 检查 ---"
if [ -f "package.json" ] && node -e "const p=require('./package.json'); process.exit(p.scripts&&p.scripts.lint?0:1)" 2>/dev/null; then
    npm run lint || { echo "Lint 失败"; ERRORS=$((ERRORS + 1)); }
elif command -v ruff >/dev/null 2>&1; then
    ruff check . || { echo "Ruff 失败"; ERRORS=$((ERRORS + 1)); }
fi
echo ""

# ─────────────────────────────────────────────
# 类型检查
# ─────────────────────────────────────────────

echo "--- 类型检查 ---"
if [ -f "package.json" ] && node -e "const p=require('./package.json'); process.exit(p.scripts&&p.scripts.typecheck?0:1)" 2>/dev/null; then
    npm run typecheck || { echo "类型检查失败"; ERRORS=$((ERRORS + 1)); }
elif [ -f "tsconfig.json" ]; then
    npx tsc --noEmit || { echo "TypeScript 检查失败"; ERRORS=$((ERRORS + 1)); }
elif command -v mypy >/dev/null 2>&1 && [ -f "pyproject.toml" ]; then
    mypy . || { echo "Mypy 失败"; ERRORS=$((ERRORS + 1)); }
fi
echo ""

# ─────────────────────────────────────────────
# 结果
# ─────────────────────────────────────────────

echo "========================================="
if [ $ERRORS -gt 0 ]; then
    echo "  发现 $ERRORS 个问题，请修复后再提交"
    exit 1
else
    echo "  所有检查通过!"
    exit 0
fi
