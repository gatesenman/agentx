# GitHub Copilot / Codex 智能体完整配置包

## 快速安装

```bash
# 1. 解压
unzip copilot-agent.zip

# 2. 复制到项目
cp copilot-agent/AGENTS.md /你的项目/
cp -r copilot-agent/.github/ /你的项目/

# 3. 复制参考文件
mkdir -p /你的项目/.agent
cp -r copilot-agent/workflows /你的项目/.agent/
cp -r copilot-agent/scripts /你的项目/.agent/
cp -r copilot-agent/hooks /你的项目/.agent/
cp -r copilot-agent/templates /你的项目/.agent/
cp copilot-agent/DECISION-TREES.md /你的项目/.agent/
cp copilot-agent/MCP-TOOLS-REFERENCE.md /你的项目/.agent/

# 4. 安装 Git hooks（可选）
cd /你的项目 && bash .agent/hooks/git-hooks-setup.sh
```

## 文件清单

```
copilot-agent/
├── AGENTS.md                              # 主规则（Copilot Workspace / Codex 加载）
├── .github/
│   └── copilot-instructions.md           # Copilot Chat 指令
├── README.md
│
├── workflows/                             # 4 个完整工作流
├── scripts/                               # 3 个可运行脚本
├── hooks/                                 # Git hooks 安装
├── templates/                             # 4 个配置模板
├── DECISION-TREES.md                      # 7 类决策树
├── MCP-TOOLS-REFERENCE.md                 # 50+ 工具参考
└── AUTOMATIONS-REFERENCE.md               # 自动化配置参考
```
