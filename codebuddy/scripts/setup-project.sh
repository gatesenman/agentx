#!/bin/bash
# ===========================================================
# 项目设置脚本 — 自动检测并配置开发环境
# ===========================================================
# 用法: bash scripts/setup-project.sh
# ===========================================================

set -e

# 颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║  项目环境自动设置工具                    ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# ===== 1. 检测项目类型 =====
echo -e "${BLUE}[1/6] 检测项目类型...${NC}"

PROJECT_TYPE=""
PACKAGE_MANAGER=""

if [ -f "package.json" ]; then
  PROJECT_TYPE="node"
  # 检测包管理器
  if [ -f "pnpm-lock.yaml" ]; then
    PACKAGE_MANAGER="pnpm"
  elif [ -f "yarn.lock" ]; then
    PACKAGE_MANAGER="yarn"
  elif [ -f "bun.lockb" ]; then
    PACKAGE_MANAGER="bun"
  else
    PACKAGE_MANAGER="npm"
  fi
  echo -e "  ${GREEN}✓${NC} Node.js 项目 (包管理器: $PACKAGE_MANAGER)"
fi

if [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "requirements.txt" ]; then
  if [ -n "$PROJECT_TYPE" ]; then
    PROJECT_TYPE="$PROJECT_TYPE+python"
  else
    PROJECT_TYPE="python"
  fi
  # 检测 Python 包管理器
  if [ -f "pyproject.toml" ] && grep -q "tool.poetry" pyproject.toml 2>/dev/null; then
    PACKAGE_MANAGER="${PACKAGE_MANAGER:+$PACKAGE_MANAGER+}poetry"
  elif [ -f "pyproject.toml" ] && grep -q "tool.uv" pyproject.toml 2>/dev/null; then
    PACKAGE_MANAGER="${PACKAGE_MANAGER:+$PACKAGE_MANAGER+}uv"
  elif [ -f "Pipfile" ]; then
    PACKAGE_MANAGER="${PACKAGE_MANAGER:+$PACKAGE_MANAGER+}pipenv"
  else
    PACKAGE_MANAGER="${PACKAGE_MANAGER:+$PACKAGE_MANAGER+}pip"
  fi
  echo -e "  ${GREEN}✓${NC} Python 项目"
fi

if [ -f "Cargo.toml" ]; then
  if [ -n "$PROJECT_TYPE" ]; then
    PROJECT_TYPE="$PROJECT_TYPE+rust"
  else
    PROJECT_TYPE="rust"
  fi
  echo -e "  ${GREEN}✓${NC} Rust 项目"
fi

if [ -f "go.mod" ]; then
  if [ -n "$PROJECT_TYPE" ]; then
    PROJECT_TYPE="$PROJECT_TYPE+go"
  else
    PROJECT_TYPE="go"
  fi
  echo -e "  ${GREEN}✓${NC} Go 项目"
fi

if [ -z "$PROJECT_TYPE" ]; then
  echo -e "  ${YELLOW}⚠ 未识别的项目类型${NC}"
fi

# ===== 2. 检测 Monorepo =====
echo ""
echo -e "${BLUE}[2/6] 检测 Monorepo 配置...${NC}"

MONOREPO=""
if [ -f "pnpm-workspace.yaml" ]; then
  MONOREPO="pnpm"
  echo -e "  ${GREEN}✓${NC} pnpm workspace"
elif [ -f "lerna.json" ]; then
  MONOREPO="lerna"
  echo -e "  ${GREEN}✓${NC} Lerna monorepo"
elif [ -f "nx.json" ]; then
  MONOREPO="nx"
  echo -e "  ${GREEN}✓${NC} Nx monorepo"
elif [ -f "turbo.json" ]; then
  MONOREPO="turbo"
  echo -e "  ${GREEN}✓${NC} Turborepo"
elif [ -f "package.json" ] && grep -q "workspaces" package.json 2>/dev/null; then
  MONOREPO="npm-workspaces"
  echo -e "  ${GREEN}✓${NC} npm workspaces"
else
  echo -e "  ${GREEN}✓${NC} 单体项目"
fi

# ===== 3. 安装依赖 =====
echo ""
echo -e "${BLUE}[3/6] 安装依赖...${NC}"

install_node_deps() {
  case "$PACKAGE_MANAGER" in
    pnpm)
      echo "  执行: pnpm install"
      pnpm install
      ;;
    yarn)
      echo "  执行: yarn install"
      yarn install
      ;;
    bun)
      echo "  执行: bun install"
      bun install
      ;;
    *)
      echo "  执行: npm install"
      npm install
      ;;
  esac
}

install_python_deps() {
  if echo "$PACKAGE_MANAGER" | grep -q "poetry"; then
    echo "  执行: poetry install"
    poetry install
  elif echo "$PACKAGE_MANAGER" | grep -q "uv"; then
    echo "  执行: uv sync"
    uv sync
  elif echo "$PACKAGE_MANAGER" | grep -q "pipenv"; then
    echo "  执行: pipenv install --dev"
    pipenv install --dev
  elif [ -f "requirements-dev.txt" ]; then
    echo "  执行: pip install -r requirements-dev.txt"
    pip install -r requirements-dev.txt
  elif [ -f "requirements.txt" ]; then
    echo "  执行: pip install -r requirements.txt"
    pip install -r requirements.txt
  elif [ -f "pyproject.toml" ]; then
    echo "  执行: pip install -e '.[dev]'"
    pip install -e '.[dev]' 2>/dev/null || pip install -e .
  fi
}

if echo "$PROJECT_TYPE" | grep -q "node"; then
  install_node_deps
fi

if echo "$PROJECT_TYPE" | grep -q "python"; then
  install_python_deps
fi

if echo "$PROJECT_TYPE" | grep -q "rust"; then
  echo "  执行: cargo build"
  cargo build
fi

if echo "$PROJECT_TYPE" | grep -q "go"; then
  echo "  执行: go mod download"
  go mod download
fi

echo -e "  ${GREEN}✓${NC} 依赖安装完成"

# ===== 4. 环境配置 =====
echo ""
echo -e "${BLUE}[4/6] 环境配置...${NC}"

# .env 文件
if [ -f ".env.example" ] && [ ! -f ".env" ]; then
  cp .env.example .env
  echo -e "  ${GREEN}✓${NC} 从 .env.example 创建 .env"
elif [ -f ".env.template" ] && [ ! -f ".env" ]; then
  cp .env.template .env
  echo -e "  ${GREEN}✓${NC} 从 .env.template 创建 .env"
else
  echo -e "  ${GREEN}✓${NC} 环境配置已就绪"
fi

# ===== 5. Git Hooks =====
echo ""
echo -e "${BLUE}[5/6] 配置 Git Hooks...${NC}"

if [ -f ".pre-commit-config.yaml" ]; then
  if command -v pre-commit &> /dev/null; then
    pre-commit install
    echo -e "  ${GREEN}✓${NC} pre-commit hooks 已安装"
  else
    echo -e "  ${YELLOW}⚠${NC} pre-commit 未安装，跳过 (pip install pre-commit)"
  fi
elif [ -f "hooks/install-hooks.sh" ]; then
  bash hooks/install-hooks.sh 2>/dev/null
  echo -e "  ${GREEN}✓${NC} 自定义 hooks 已安装"
elif [ -f ".husky/_/husky.sh" ] || grep -q "husky" package.json 2>/dev/null; then
  if [ -f "package.json" ]; then
    npx husky install 2>/dev/null || true
    echo -e "  ${GREEN}✓${NC} Husky hooks 已安装"
  fi
else
  echo -e "  ${GREEN}✓${NC} 无需额外 hooks 配置"
fi

# ===== 6. 验证 =====
echo ""
echo -e "${BLUE}[6/6] 验证环境...${NC}"

# 构建
if echo "$PROJECT_TYPE" | grep -q "node"; then
  if grep -q '"build"' package.json 2>/dev/null; then
    echo -n "  构建测试..."
    if npm run build 2>/dev/null; then
      echo -e " ${GREEN}PASS${NC}"
    else
      echo -e " ${YELLOW}WARN (构建有问题)${NC}"
    fi
  fi
fi

# Lint
if echo "$PROJECT_TYPE" | grep -q "node"; then
  if grep -q '"lint"' package.json 2>/dev/null; then
    echo -n "  Lint 测试..."
    if npm run lint 2>/dev/null; then
      echo -e " ${GREEN}PASS${NC}"
    else
      echo -e " ${YELLOW}WARN (有 lint 问题)${NC}"
    fi
  fi
fi

# 测试
echo -n "  测试运行..."
if echo "$PROJECT_TYPE" | grep -q "node"; then
  if npm test -- --passWithNoTests --bail --watchAll=false 2>/dev/null; then
    echo -e " ${GREEN}PASS${NC}"
  else
    echo -e " ${YELLOW}WARN (有测试失败)${NC}"
  fi
elif echo "$PROJECT_TYPE" | grep -q "python"; then
  if pytest --tb=short -q 2>/dev/null; then
    echo -e " ${GREEN}PASS${NC}"
  else
    echo -e " ${YELLOW}WARN (有测试失败)${NC}"
  fi
else
  echo -e " ${GREEN}SKIP${NC}"
fi

# ===== 完成 =====
echo ""
echo "╔══════════════════════════════════════════╗"
echo -e "║  ${GREEN}✅ 项目设置完成!${NC}                        ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "  项目类型: $PROJECT_TYPE"
echo "  包管理器: $PACKAGE_MANAGER"
[ -n "$MONOREPO" ] && echo "  Monorepo: $MONOREPO"
echo ""
echo "  下一步:"
echo "    • 运行 dev server: npm run dev / python manage.py runserver"
echo "    • 运行测试: npm test / pytest"
echo "    • 检查 lint: npm run lint / ruff check ."
echo ""
