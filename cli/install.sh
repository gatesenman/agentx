#!/usr/bin/env bash
# ============================================================================
# AgentX CLI 一键安装脚本
# 用法: curl -fsSL https://raw.githubusercontent.com/gaosichun888/agentx/main/cli/install.sh | bash
# 或:   wget -qO- https://raw.githubusercontent.com/gaosichun888/agentx/main/cli/install.sh | bash
# ============================================================================

set -euo pipefail

# ---- 配置 ----
REPO_URL="https://github.com/gaosichun888/agentx"
INSTALL_DIR="${AGENTX_INSTALL_DIR:-${HOME}/.agentx}"
BIN_DIR="${HOME}/.local/bin"

# ---- 颜色 ----
if [[ -t 1 ]]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BLUE='\033[0;34m'
  BOLD='\033[1m'
  NC='\033[0m'
else
  RED='' GREEN='' YELLOW='' BLUE='' BOLD='' NC=''
fi

info()  { echo -e "${GREEN}[✓]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
error() { echo -e "${RED}[✗]${NC} $*" >&2; }
step()  { echo -e "${BLUE}[→]${NC} $*"; }

# ---- 主逻辑 ----
main() {
  echo ""
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}  AgentX CLI 安装程序${NC}"
  echo -e "${BOLD}  AI 智能体配置管理工具${NC}"
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""

  # 检查 git
  if ! command -v git &>/dev/null; then
    error "需要安装 git。请访问: https://git-scm.com/"
    exit 1
  fi

  # 1. 下载/更新仓库
  if [[ -d "$INSTALL_DIR/repo/.git" ]]; then
    step "更新 AgentX 配置源..."
    (cd "$INSTALL_DIR/repo" && git pull origin main 2>/dev/null) || {
      warn "更新失败，重新克隆..."
      rm -rf "$INSTALL_DIR/repo"
      git clone --depth 1 "$REPO_URL.git" "$INSTALL_DIR/repo"
    }
  else
    step "下载 AgentX 配置源..."
    mkdir -p "$INSTALL_DIR"
    rm -rf "$INSTALL_DIR/repo"
    git clone --depth 1 "$REPO_URL.git" "$INSTALL_DIR/repo"
  fi
  info "配置源已就绪"

  # 2. 安装 CLI 到 PATH
  step "安装 agentx 命令..."
  mkdir -p "$BIN_DIR"
  cp "$INSTALL_DIR/repo/cli/agentx" "$BIN_DIR/agentx"
  chmod +x "$BIN_DIR/agentx"
  info "已安装到 $BIN_DIR/agentx"

  # 3. 检查 PATH
  if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    warn "$BIN_DIR 不在 PATH 中"
    echo ""
    echo "  请将以下行添加到你的 shell 配置文件中:"
    echo ""

    local shell_name
    shell_name="$(basename "${SHELL:-/bin/bash}")"

    case "$shell_name" in
      zsh)
        echo "    echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc"
        echo "    source ~/.zshrc"
        ;;
      fish)
        echo "    fish_add_path $BIN_DIR"
        ;;
      *)
        echo "    echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
        echo "    source ~/.bashrc"
        ;;
    esac
    echo ""
  fi

  # 4. 设置环境变量指向配置源
  export AGENTX_CACHE_DIR="$INSTALL_DIR"

  # 5. 完成
  echo ""
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${GREEN}${BOLD}  安装完成！${NC}"
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo "  快速开始:"
  echo ""
  echo "    agentx list                    # 查看支持的 IDE"
  echo "    agentx install claude-code     # 安装 Claude Code 配置"
  echo "    agentx install cursor          # 安装 Cursor 配置"
  echo "    agentx hooks                   # 安装 Git Hooks"
  echo "    agentx doctor                  # 诊断配置"
  echo "    agentx help                    # 查看所有命令"
  echo ""
  echo "  文档: ${REPO_URL}/wiki"
  echo ""
}

main "$@"
