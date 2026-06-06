# OpenAI Codex CLI — 智能体完整配置

> 规则格式: `AGENTS.md`

## 快速安装

```bash
# 方式1: 项目级（推荐）
cp AGENTS.md /你的项目/

# 方式2: 全局（所有项目生效）
mkdir -p ~/.codex && cp AGENTS.md ~/.codex/

# 复制参考文件（推荐）
cp -r workflows/ hooks/ scripts/ templates/ /你的项目/.agent/
cp *.md /你的项目/.agent/

# 安装 Git hooks（可选）
bash hooks/install-hooks.sh
```

## 文件结构

```
codex/
│
│  ── 核心规则 ──
├── AGENTS.md                              # 主规则（Codex 自动加载）
│
│  ── 参考文档 ──
├── MCP-TOOLS-REFERENCE.md                 # 50+ 工具完整参考
├── MEMORY-SYSTEM.md                       # 7 层记忆架构
├── SKILLS-REFERENCE.md                    # 技能系统参考
├── DECISION-TREES.md                      # 10 类决策树
├── AUTOMATIONS-REFERENCE.md               # 自动化/Hook 配置
├── TROUBLESHOOTING.md                     # 常见问题排查
├── PROMPT-PATTERNS.md                     # 提示词模式
├── TOOL-CHAINS.md                         # 工具链编排
│
│  ── 工作流 ──
├── workflows/
│   ├── PLAYBOOK-bug-fix.md               #   Bug 修复
│   ├── PLAYBOOK-feature-implementation.md #   功能实现
│   ├── PLAYBOOK-ci-fix.md                #   CI 修复
│   └── PLAYBOOK-refactoring.md           #   重构
│
│  ── Git Hooks ──
├── hooks/
│   ├── pre-commit                        #   密钥检测 + lint
│   ├── commit-msg                        #   Conventional Commits
│   ├── pre-push                          #   分支保护 + 测试
│   └── install-hooks.sh                  #   一键安装
│
│  ── 脚本 ──
├── scripts/
│   ├── setup-project.sh                  #   项目自动设置
│   └── verify-no-secrets.sh              #   密钥扫描
│
│  ── 模板 ──
├── templates/
│   ├── environment.yaml                  #   环境蓝图
│   ├── pr-template.md                    #   PR 描述
│   ├── pre-commit-config.yaml            #   pre-commit 配置
│   └── gitignore.template                #   .gitignore
│
└── README.md
```

## 零外部依赖

所有引用的脚本、模板、配置均已包含。无需额外下载。
