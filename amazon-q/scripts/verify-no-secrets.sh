#!/bin/bash
# =============================================================================
# 密钥泄露检查脚本 — 扫描代码中的潜在密钥
# 用法: bash verify-no-secrets.sh [目录]
# =============================================================================

DIR="${1:-.}"

echo "扫描目录: $DIR"
echo ""

FOUND=0

# 高置信度模式（可能是真正的密钥）
PATTERNS=(
    'AKIA[0-9A-Z]{16}'                           # AWS Access Key
    'sk-[a-zA-Z0-9]{20,}'                         # OpenAI/Stripe Secret Key
    'ghp_[a-zA-Z0-9]{36}'                         # GitHub Personal Token
    'gho_[a-zA-Z0-9]{36}'                         # GitHub OAuth Token
    'github_pat_[a-zA-Z0-9]{22}_[a-zA-Z0-9]{59}'  # GitHub Fine-grained PAT
    'xoxb-[0-9]{11}-[0-9]{11}-[a-zA-Z0-9]{24}'   # Slack Bot Token
    'xoxp-[0-9]{11}-[0-9]{11}-[a-zA-Z0-9]{24}'   # Slack User Token
    'sk_live_[a-zA-Z0-9]{24,}'                     # Stripe Live Key
    'rk_live_[a-zA-Z0-9]{24,}'                     # Stripe Restricted Key
    'SG\.[a-zA-Z0-9_-]{22}\.[a-zA-Z0-9_-]{43}'   # SendGrid API Key
    'key-[a-zA-Z0-9]{32}'                          # Mailgun API Key
    'sq0csp-[a-zA-Z0-9_-]{43}'                     # Square Access Token
)

for pattern in "${PATTERNS[@]}"; do
    MATCHES=$(grep -rnE "$pattern" "$DIR" \
        --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" \
        --include="*.py" --include="*.rb" --include="*.go" --include="*.rs" \
        --include="*.java" --include="*.yml" --include="*.yaml" --include="*.json" \
        --include="*.toml" --include="*.cfg" --include="*.ini" --include="*.env*" \
        --exclude-dir="node_modules" --exclude-dir=".git" --exclude-dir="vendor" \
        --exclude-dir="dist" --exclude-dir="build" \
        2>/dev/null || true)

    if [ -n "$MATCHES" ]; then
        echo "发现可疑密钥模式: $pattern"
        echo "$MATCHES" | head -5
        echo ""
        FOUND=$((FOUND + 1))
    fi
done

# 检查敏感文件
echo "--- 检查敏感文件 ---"
SENSITIVE_FILES=$(find "$DIR" \
    -name ".env" -o -name ".env.local" -o -name ".env.production" \
    -o -name "credentials.json" -o -name "service-account*.json" \
    -o -name "id_rsa" -o -name "id_ed25519" -o -name "*.pem" \
    -o -name "*.key" -o -name "*.p12" \
    2>/dev/null | grep -v node_modules | grep -v .git || true)

if [ -n "$SENSITIVE_FILES" ]; then
    echo "发现敏感文件:"
    echo "$SENSITIVE_FILES"
    FOUND=$((FOUND + 1))
fi

echo ""
echo "========================================="
if [ $FOUND -gt 0 ]; then
    echo "发现 $FOUND 类可疑内容，请检查后再提交"
    exit 1
else
    echo "未发现密钥泄露"
    exit 0
fi
