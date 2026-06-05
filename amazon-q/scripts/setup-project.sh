#!/bin/bash
# =============================================================================
# 项目设置脚本 — 自动检测项目类型并安装依赖
# 用法: bash setup-project.sh [项目目录]
# =============================================================================

set -e

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR"

echo "========================================="
echo "  项目设置脚本"
echo "  目录: $(pwd)"
echo "========================================="

# ─────────────────────────────────────────────
# 检测项目类型
# ─────────────────────────────────────────────

detect_project_type() {
    local types=""
    [ -f "package.json" ] && types="${types}node "
    [ -f "pyproject.toml" ] || [ -f "requirements.txt" ] || [ -f "setup.py" ] && types="${types}python "
    [ -f "Cargo.toml" ] && types="${types}rust "
    [ -f "go.mod" ] && types="${types}go "
    [ -f "Gemfile" ] && types="${types}ruby "
    [ -f "pom.xml" ] || [ -f "build.gradle" ] && types="${types}java "
    echo "$types"
}

PROJECT_TYPES=$(detect_project_type)
echo "检测到项目类型: ${PROJECT_TYPES:-未知}"

# ─────────────────────────────────────────────
# Node.js 项目
# ─────────────────────────────────────────────

setup_node() {
    echo ""
    echo "--- Node.js 设置 ---"

    # 检测包管理器
    if [ -f "pnpm-lock.yaml" ]; then
        PKG_MGR="pnpm"
        echo "包管理器: pnpm"
        command -v pnpm >/dev/null || npm install -g pnpm
        pnpm install
    elif [ -f "yarn.lock" ]; then
        PKG_MGR="yarn"
        echo "包管理器: yarn"
        command -v yarn >/dev/null || npm install -g yarn
        yarn install
    elif [ -f "bun.lockb" ]; then
        PKG_MGR="bun"
        echo "包管理器: bun"
        command -v bun >/dev/null || curl -fsSL https://bun.sh/install | bash
        bun install
    else
        PKG_MGR="npm"
        echo "包管理器: npm"
        npm install
    fi

    # 检查可用脚本
    echo ""
    echo "可用脚本:"
    node -e "
    const pkg = require('./package.json');
    const scripts = pkg.scripts || {};
    Object.entries(scripts).forEach(([k,v]) => console.log('  ' + k + ': ' + v));
    " 2>/dev/null || echo "  (无法读取 package.json)"

    # 尝试构建
    if node -e "const p=require('./package.json'); process.exit(p.scripts && p.scripts.build ? 0 : 1)" 2>/dev/null; then
        echo ""
        echo "运行构建..."
        $PKG_MGR run build || echo "⚠ 构建失败，但继续设置"
    fi
}

# ─────────────────────────────────────────────
# Python 项目
# ─────────────────────────────────────────────

setup_python() {
    echo ""
    echo "--- Python 设置 ---"

    # 检测 Python 版本管理
    if [ -f "pyproject.toml" ] && grep -q "uv" pyproject.toml 2>/dev/null; then
        echo "工具: uv"
        command -v uv >/dev/null || curl -LsSf https://astral.sh/uv/install.sh | sh
        uv sync
    elif [ -f "Pipfile" ]; then
        echo "工具: pipenv"
        command -v pipenv >/dev/null || pip install pipenv
        pipenv install --dev
    elif [ -f "pyproject.toml" ]; then
        echo "工具: pip (pyproject.toml)"
        pip install -e ".[dev]" 2>/dev/null || pip install -e .
    elif [ -f "requirements.txt" ]; then
        echo "工具: pip (requirements.txt)"
        pip install -r requirements.txt
        [ -f "requirements-dev.txt" ] && pip install -r requirements-dev.txt
    elif [ -f "setup.py" ]; then
        echo "工具: pip (setup.py)"
        pip install -e .
    fi
}

# ─────────────────────────────────────────────
# Rust 项目
# ─────────────────────────────────────────────

setup_rust() {
    echo ""
    echo "--- Rust 设置 ---"
    command -v cargo >/dev/null || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    cargo build
}

# ─────────────────────────────────────────────
# Go 项目
# ─────────────────────────────────────────────

setup_go() {
    echo ""
    echo "--- Go 设置 ---"
    go mod download
    go build ./...
}

# ─────────────────────────────────────────────
# Pre-commit 设置
# ─────────────────────────────────────────────

setup_precommit() {
    if [ -f ".pre-commit-config.yaml" ]; then
        echo ""
        echo "--- Pre-commit 设置 ---"
        command -v pre-commit >/dev/null || pip install pre-commit
        pre-commit install
        echo "Pre-commit hooks 已安装"
    fi
}

# ─────────────────────────────────────────────
# 执行设置
# ─────────────────────────────────────────────

for type in $PROJECT_TYPES; do
    case $type in
        node)   setup_node ;;
        python) setup_python ;;
        rust)   setup_rust ;;
        go)     setup_go ;;
    esac
done

setup_precommit

echo ""
echo "========================================="
echo "  设置完成!"
echo "========================================="
