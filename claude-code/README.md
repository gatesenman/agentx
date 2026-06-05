# Claude Code 智能体完整配置包

## 快速安装

```bash
# 1. 解压
unzip claude-code-agent.zip

# 2. 复制核心文件到项目根目录
cp claude-code-agent/CLAUDE.md /你的项目/
cp claude-code-agent/CLAUDE.local.md /你的项目/

# 3. 复制参考文件（可选，放在 .agent/ 下供 agent 参考）
mkdir -p /你的项目/.agent
cp -r claude-code-agent/workflows /你的项目/.agent/
cp -r claude-code-agent/scripts /你的项目/.agent/
cp -r claude-code-agent/hooks /你的项目/.agent/
cp -r claude-code-agent/templates /你的项目/.agent/
cp claude-code-agent/DECISION-TREES.md /你的项目/.agent/
cp claude-code-agent/MCP-TOOLS-REFERENCE.md /你的项目/.agent/
cp claude-code-agent/AUTOMATIONS-REFERENCE.md /你的项目/.agent/

# 4. 安装 Git hooks（可选）
cd /你的项目 && bash .agent/hooks/git-hooks-setup.sh

# 5. 加到 .gitignore
echo "CLAUDE.local.md" >> .gitignore
```

## 文件清单

```
claude-code-agent/
├── CLAUDE.md                              # 主规则文件（Claude Code 自动加载）
├── CLAUDE.local.md                        # 本地个人覆盖（不提交 Git）
├── README.md                              # 本文件
│
├── workflows/                             # 完整工作流（含脚本和命令）
│   ├── PLAYBOOK-bug-fix.md               #   Bug 修复流程（含复现脚本、定位命令、验证步骤）
│   ├── PLAYBOOK-feature-implementation.md #   功能实现流程（含探索命令、编码规范、PR 流程）
│   ├── PLAYBOOK-refactoring.md           #   重构流程（含安全步骤、重命名脚本）
│   └── PLAYBOOK-ci-fix.md               #   CI 修复流程（含各类错误的修复命令）
│
├── scripts/                               # 可运行脚本
│   ├── setup-project.sh                  #   自动检测项目类型并安装依赖
│   ├── pre-commit-check.sh               #   提交前检查（密钥+lint+类型）
│   └── verify-no-secrets.sh              #   密钥泄露扫描
│
├── hooks/                                 # Git hooks
│   └── git-hooks-setup.sh                #   一键安装 pre-commit/commit-msg/pre-push hooks
│
├── templates/                             # 配置模板
│   ├── environment.yaml                  #   Devin 环境蓝图模板
│   ├── pr-template.md                    #   PR 描述模板
│   ├── pre-commit-config.yaml            #   .pre-commit-config.yaml 模板
│   └── gitignore-template                #   .gitignore 模板（含敏感文件规则）
│
├── DECISION-TREES.md                      # 7 类决策树（任务路由/PR/并行/Git/凭据/错误/通信）
├── MCP-TOOLS-REFERENCE.md                 # 50+ 工具完整参考（含参数和用法）
└── AUTOMATIONS-REFERENCE.md               # 自动化和 Hook 配置参考
```

## 所有文件说明

| 文件 | 类型 | 说明 |
|------|------|------|
| CLAUDE.md | 规则 | Claude Code 主规则，含核心原则、代码质量、Git 规则、PR 工作流等完整配置 |
| CLAUDE.local.md | 配置 | 个人偏好覆盖（语言、风格、技术栈、团队约定），不提交 Git |
| workflows/*.md | 工作流 | 4 个完整工作流，每个含详细步骤、命令、决策树、脚本 |
| scripts/*.sh | 脚本 | 3 个可运行脚本，开箱即用 |
| hooks/*.sh | Git hook | Git hooks 安装脚本，含 pre-commit/commit-msg/pre-push |
| templates/* | 模板 | 4 个配置模板，直接复制使用 |
| DECISION-TREES.md | 参考 | 完整决策逻辑，覆盖所有场景 |
| MCP-TOOLS-REFERENCE.md | 参考 | 所有可用工具的完整说明 |
| AUTOMATIONS-REFERENCE.md | 参考 | 自动化配置和事件钩子说明 |

## 零外部依赖

所有引用的脚本、模板、配置都已包含在包内。没有任何文件引用包外的资源。
