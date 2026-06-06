# Cursor IDE — 智能体完整配置

> 规则格式: `.cursorrules + .cursor/rules/*.mdc`

## 快速安装

```bash
# 复制核心规则到项目根目录
cp .cursorrules /你的项目/
cp -r .cursor/ /你的项目/

# 复制参考文件（推荐）
cp -r workflows/ hooks/ scripts/ templates/ /你的项目/.agent/
cp *.md /你的项目/.agent/

# 安装 Git hooks（可选）
bash hooks/install-hooks.sh
```

## 文件结构

```
cursor/
│
│  ── 核心规则 ──
├── .cursorrules                           # 全局规则（自动加载）
├── .cursor/rules/
│   ├── code-quality.mdc                  #   代码质量（alwaysApply: true）
│   ├── debugging.mdc                     #   调试（按场景触发）
│   ├── git-workflow.mdc                  #   Git/PR 工作流
│   ├── repo-setup.mdc                    #   仓库设置
│   └── testing.mdc                       #   测试
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
