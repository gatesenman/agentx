# Claude Code 智能体完整配置包

## 快速安装

```bash
# 1. 复制核心文件到项目根目录
cp CLAUDE.md /你的项目/
cp CLAUDE.local.md /你的项目/

# 2. 复制参考文件（可选，放在 .agent/ 下供 agent 参考）
mkdir -p /你的项目/.agent
cp -r workflows/ scripts/ hooks/ templates/ /你的项目/.agent/
cp MCP-TOOLS-REFERENCE.md MEMORY-SYSTEM.md SKILLS-REFERENCE.md /你的项目/.agent/
cp DECISION-TREES.md AUTOMATIONS-REFERENCE.md /你的项目/.agent/
cp TROUBLESHOOTING.md PROMPT-PATTERNS.md TOOL-CHAINS.md /你的项目/.agent/

# 3. 安装 Git hooks（可选）
cd /你的项目 && bash .agent/hooks/install-hooks.sh

# 4. 加到 .gitignore
echo "CLAUDE.local.md" >> .gitignore
```

## 文件清单

```
claude-code/
├── CLAUDE.md                              # 主规则文件（Claude Code 自动加载）
├── CLAUDE.local.md                        # 本地个人覆盖（不提交 Git）
│
├── workflows/                             # 工作流 Playbook
│   ├── PLAYBOOK-bug-fix.md               #   Bug 修复完整流程 (219行)
│   ├── PLAYBOOK-feature-implementation.md #   功能实现完整流程 (210行)
│   ├── PLAYBOOK-ci-fix.md                #   CI 修复完整流程 (240行)
│   └── PLAYBOOK-refactoring.md           #   重构完整流程 (200行)
│
├── hooks/                                 # Git Hooks (完整可执行 bash)
│   ├── pre-commit                        #   密钥检测+lint+类型检查 (185行)
│   ├── commit-msg                        #   Conventional Commits 验证 (88行)
│   ├── pre-push                          #   分支保护+测试+构建 (124行)
│   └── install-hooks.sh                  #   一键安装脚本 (73行)
│
├── scripts/                               # 可运行脚本
│   ├── setup-project.sh                  #   自动检测项目类型并安装依赖 (274行)
│   └── verify-no-secrets.sh              #   10类密钥深度扫描 (212行)
│
├── templates/                             # 配置模板
│   ├── environment.yaml                  #   Devin 环境蓝图模板
│   ├── pr-template.md                    #   PR 描述模板
│   ├── pre-commit-config.yaml            #   .pre-commit-config.yaml 模板
│   └── gitignore-template                #   .gitignore 安全模板
│
├── MCP-TOOLS-REFERENCE.md                 # 50+ 工具完整参考 (445行)
├── MEMORY-SYSTEM.md                       # 7层记忆架构参考 (303行)
├── SKILLS-REFERENCE.md                    # 技能系统完整参考 (255行)
├── DECISION-TREES.md                      # 10类完整决策树 (361行)
├── AUTOMATIONS-REFERENCE.md               # 自动化和 Hook 配置参考 (321行)
├── TROUBLESHOOTING.md                     # 常见问题排查指南 (10大类)
├── PROMPT-PATTERNS.md                     # 10类提示词模式+反模式
├── TOOL-CHAINS.md                         # 30+场景端到端工具链编排
└── README.md                              # 本文件
```

## 文件说明

| 类别 | 文件 | 说明 |
|------|------|------|
| 规则 | CLAUDE.md | 主规则: 核心原则、代码质量、Git规则、PR工作流、任务管理等 |
| 配置 | CLAUDE.local.md | 个人偏好覆盖（语言、风格、技术栈），不提交 Git |
| 工作流 | workflows/*.md | 4个完整工作流，含详细步骤、命令、决策分支 |
| Hooks | hooks/* | 3个Git hook + 安装脚本，开箱即用 |
| 脚本 | scripts/*.sh | 项目自动设置 + 密钥扫描 |
| 模板 | templates/* | 环境蓝图、PR、pre-commit、gitignore 模板 |
| 工具 | MCP-TOOLS-REFERENCE.md | 50+工具的参数、触发条件、使用场景 |
| 记忆 | MEMORY-SYSTEM.md | 7层记忆架构、知识系统、跨会话持久化 |
| 技能 | SKILLS-REFERENCE.md | 8个内置技能 + 自定义技能开发 |
| 决策 | DECISION-TREES.md | 10类决策树: 路由/工具/并行/Git/PR/通信 |
| 自动化 | AUTOMATIONS-REFERENCE.md | 事件驱动自动化 + Hook 配置 |
| 排查 | TROUBLESHOOTING.md | 10大类常见问题的系统化排查 |
| 提示词 | PROMPT-PATTERNS.md | 10类高效提示词模式 + 反模式 |
| 工具链 | TOOL-CHAINS.md | 30+场景的端到端工具调用序列 |

## 零外部依赖

所有引用的脚本、模板、配置都已包含在包内。没有任何文件引用包外的资源。
