#!/bin/bash
# ===========================================================
# 密钥泄露扫描脚本 — 全仓库深度扫描
# ===========================================================
# 用法: bash scripts/verify-no-secrets.sh [目标目录]
# ===========================================================

set -e

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TARGET_DIR="${1:-.}"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║  密钥泄露深度扫描工具                    ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "  扫描目录: $TARGET_DIR"
echo ""

ISSUES_FOUND=0
WARNINGS=0

# ===== 1. AWS 密钥 =====
echo -n "  [1/10] AWS Access Keys..."
AWS_KEYS=$(grep -rn "AKIA[0-9A-Z]\{16\}" "$TARGET_DIR" \
  --include="*.ts" --include="*.js" --include="*.py" --include="*.env" \
  --include="*.yml" --include="*.yaml" --include="*.json" --include="*.toml" \
  --include="*.cfg" --include="*.conf" --include="*.ini" \
  --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=vendor \
  2>/dev/null || true)

if [ -n "$AWS_KEYS" ]; then
  echo -e " ${RED}FOUND${NC}"
  echo "$AWS_KEYS" | while read -r line; do echo "    $line"; done
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
  echo -e " ${GREEN}CLEAN${NC}"
fi

# ===== 2. OpenAI / Anthropic API Keys =====
echo -n "  [2/10] AI API Keys (OpenAI/Anthropic)..."
AI_KEYS=$(grep -rn "sk-[a-zA-Z0-9]\{48,\}\|sk-ant-[a-zA-Z0-9-]\{90,\}" "$TARGET_DIR" \
  --include="*.ts" --include="*.js" --include="*.py" --include="*.env" \
  --include="*.yml" --include="*.yaml" --include="*.json" \
  --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=vendor \
  2>/dev/null || true)

if [ -n "$AI_KEYS" ]; then
  echo -e " ${RED}FOUND${NC}"
  echo "$AI_KEYS" | while read -r line; do echo "    $line"; done
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
  echo -e " ${GREEN}CLEAN${NC}"
fi

# ===== 3. GitHub Tokens =====
echo -n "  [3/10] GitHub Tokens..."
GH_TOKENS=$(grep -rn "ghp_[a-zA-Z0-9]\{36\}\|gho_[a-zA-Z0-9]\{36\}\|github_pat_[a-zA-Z0-9_]\{82\}" "$TARGET_DIR" \
  --include="*.ts" --include="*.js" --include="*.py" --include="*.env" \
  --include="*.yml" --include="*.yaml" --include="*.json" --include="*.md" \
  --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=vendor \
  2>/dev/null || true)

if [ -n "$GH_TOKENS" ]; then
  echo -e " ${RED}FOUND${NC}"
  echo "$GH_TOKENS" | while read -r line; do echo "    $line"; done
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
  echo -e " ${GREEN}CLEAN${NC}"
fi

# ===== 4. Slack Tokens =====
echo -n "  [4/10] Slack Tokens..."
SLACK_TOKENS=$(grep -rn "xox[baprs]-[a-zA-Z0-9-]\{10,\}" "$TARGET_DIR" \
  --include="*.ts" --include="*.js" --include="*.py" --include="*.env" \
  --include="*.yml" --include="*.yaml" --include="*.json" \
  --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=vendor \
  2>/dev/null || true)

if [ -n "$SLACK_TOKENS" ]; then
  echo -e " ${RED}FOUND${NC}"
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
  echo -e " ${GREEN}CLEAN${NC}"
fi

# ===== 5. Stripe Keys =====
echo -n "  [5/10] Stripe Keys..."
STRIPE_KEYS=$(grep -rn "sk_live_[a-zA-Z0-9]\{24,\}\|pk_live_[a-zA-Z0-9]\{24,\}" "$TARGET_DIR" \
  --include="*.ts" --include="*.js" --include="*.py" --include="*.env" \
  --include="*.yml" --include="*.yaml" --include="*.json" \
  --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=vendor \
  2>/dev/null || true)

if [ -n "$STRIPE_KEYS" ]; then
  echo -e " ${RED}FOUND${NC}"
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
  echo -e " ${GREEN}CLEAN${NC}"
fi

# ===== 6. Private Keys =====
echo -n "  [6/10] Private Keys..."
PRIV_KEYS=$(grep -rn "BEGIN \(RSA \|EC \|DSA \)\?PRIVATE KEY" "$TARGET_DIR" \
  --include="*.ts" --include="*.js" --include="*.py" --include="*.pem" \
  --include="*.key" --include="*.env" --include="*.yml" --include="*.yaml" \
  --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=vendor \
  2>/dev/null || true)

if [ -n "$PRIV_KEYS" ]; then
  echo -e " ${RED}FOUND${NC}"
  echo "$PRIV_KEYS" | while read -r line; do echo "    $line"; done
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
  echo -e " ${GREEN}CLEAN${NC}"
fi

# ===== 7. JWT Tokens (长字符串) =====
echo -n "  [7/10] Hardcoded JWTs..."
JWT_TOKENS=$(grep -rn "eyJ[a-zA-Z0-9]\{30,\}\.eyJ" "$TARGET_DIR" \
  --include="*.ts" --include="*.js" --include="*.py" --include="*.env" \
  --include="*.json" \
  --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=vendor \
  --exclude="*.test.*" --exclude="*spec.*" --exclude="*mock*" \
  2>/dev/null || true)

if [ -n "$JWT_TOKENS" ]; then
  echo -e " ${YELLOW}WARN${NC}"
  WARNINGS=$((WARNINGS + 1))
else
  echo -e " ${GREEN}CLEAN${NC}"
fi

# ===== 8. 密码硬编码 =====
echo -n "  [8/10] Hardcoded Passwords..."
PASSWORDS=$(grep -rn "password\s*[=:]\s*['\"][^'\"]\{8,\}['\"]" "$TARGET_DIR" \
  --include="*.ts" --include="*.js" --include="*.py" --include="*.json" \
  --include="*.yml" --include="*.yaml" \
  --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=vendor \
  --exclude="*.test.*" --exclude="*spec.*" --exclude="*example*" \
  --exclude="*template*" --exclude="*mock*" \
  2>/dev/null || true)

if [ -n "$PASSWORDS" ]; then
  echo -e " ${YELLOW}WARN (review needed)${NC}"
  echo "$PASSWORDS" | head -5 | while read -r line; do echo "    $line"; done
  WARNINGS=$((WARNINGS + 1))
else
  echo -e " ${GREEN}CLEAN${NC}"
fi

# ===== 9. .env 文件在版本控制中 =====
echo -n "  [9/10] .env in git..."
ENV_IN_GIT=$(git ls-files "*.env" ".env.*" 2>/dev/null | grep -v "example\|template\|sample" || true)

if [ -n "$ENV_IN_GIT" ]; then
  echo -e " ${RED}FOUND${NC}"
  echo "$ENV_IN_GIT" | while read -r line; do echo "    $line"; done
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
  echo -e " ${GREEN}CLEAN${NC}"
fi

# ===== 10. .gitignore 检查 =====
echo -n "  [10/10] .gitignore 覆盖..."

GITIGNORE_ISSUES=""
if [ -f ".gitignore" ]; then
  if ! grep -q "\.env" .gitignore 2>/dev/null; then
    GITIGNORE_ISSUES="$GITIGNORE_ISSUES .env"
  fi
  if ! grep -q "node_modules" .gitignore 2>/dev/null && [ -d "node_modules" ]; then
    GITIGNORE_ISSUES="$GITIGNORE_ISSUES node_modules"
  fi
fi

if [ -n "$GITIGNORE_ISSUES" ]; then
  echo -e " ${YELLOW}WARN${NC}"
  echo -e "    建议添加到 .gitignore:$GITIGNORE_ISSUES"
  WARNINGS=$((WARNINGS + 1))
else
  echo -e " ${GREEN}CLEAN${NC}"
fi

# ===== 结果汇总 =====
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $ISSUES_FOUND -gt 0 ]; then
  echo -e "${RED}❌ 发现 $ISSUES_FOUND 个严重问题${NC}"
  echo ""
  echo "  建议操作:"
  echo "  1. 立即移除泄露的密钥"
  echo "  2. 轮换所有已泄露的凭据"
  echo "  3. 检查 git 历史是否有泄露:"
  echo "     git log --all -p -S 'AKIA' -- '*.ts' '*.py'"
  echo "  4. 如果已推送，考虑使用 git-filter-repo 清除历史"
  exit 1
elif [ $WARNINGS -gt 0 ]; then
  echo -e "${YELLOW}⚠️  发现 $WARNINGS 个警告（需要人工审查）${NC}"
  exit 0
else
  echo -e "${GREEN}✅ 未发现密钥泄露${NC}"
  exit 0
fi
