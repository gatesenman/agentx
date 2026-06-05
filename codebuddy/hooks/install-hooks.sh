#!/bin/bash
# ===========================================================
# Git Hooks 一键安装脚本
# ===========================================================
# 用法: bash hooks/install-hooks.sh
# ===========================================================

set -e

# 颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "╔══════════════════════════════════════╗"
echo "║  Git Hooks 安装工具                  ║"
echo "╚══════════════════════════════════════╝"
echo ""

# 检查是否在 git 仓库中
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo -e "${RED}错误: 当前目录不是 git 仓库${NC}"
  echo "请在项目根目录运行此脚本"
  exit 1
fi

GIT_DIR=$(git rev-parse --git-dir)
HOOKS_DIR="$GIT_DIR/hooks"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 创建 hooks 目录
mkdir -p "$HOOKS_DIR"

# 安装每个 hook
HOOKS=("pre-commit" "commit-msg" "pre-push")

for hook in "${HOOKS[@]}"; do
  SOURCE="$SCRIPT_DIR/$hook"
  TARGET="$HOOKS_DIR/$hook"

  if [ -f "$SOURCE" ]; then
    # 备份已有的 hook
    if [ -f "$TARGET" ] && [ ! -L "$TARGET" ]; then
      BACKUP="$TARGET.backup.$(date +%s)"
      cp "$TARGET" "$BACKUP"
      echo -e "  ${YELLOW}备份已有 $hook → $(basename $BACKUP)${NC}"
    fi

    cp "$SOURCE" "$TARGET"
    chmod +x "$TARGET"
    echo -e "  ${GREEN}✓${NC} $hook 已安装"
  else
    echo -e "  ${YELLOW}⚠${NC} $hook 源文件不存在，跳过"
  fi
done

echo ""
echo -e "${GREEN}安装完成!${NC}"
echo ""
echo "已安装的 hooks:"
echo "  • pre-commit  — 密钥检测、lint、类型检查"
echo "  • commit-msg  — Conventional Commits 格式验证"
echo "  • pre-push    — 分支保护、测试、构建"
echo ""
echo "跳过 hook 检查 (不推荐):"
echo "  git commit --no-verify"
echo "  git push --no-verify"
echo ""
echo "卸载 hooks:"
echo "  rm .git/hooks/{pre-commit,commit-msg,pre-push}"
echo ""
