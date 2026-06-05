# Windsurf 智能体完整配置包

## 快速安装

```bash
# 1. 解压
unzip windsurf-agent.zip

# 2. 复制到项目
cp windsurf-agent/.windsurfrules /你的项目/
cp -r windsurf-agent/.windsurf/ /你的项目/

# 3. 复制参考文件
mkdir -p /你的项目/.agent
cp -r windsurf-agent/workflows /你的项目/.agent/
cp -r windsurf-agent/scripts /你的项目/.agent/
cp -r windsurf-agent/hooks /你的项目/.agent/
cp -r windsurf-agent/templates /你的项目/.agent/
cp windsurf-agent/DECISION-TREES.md /你的项目/.agent/
cp windsurf-agent/MCP-TOOLS-REFERENCE.md /你的项目/.agent/

# 4. 安装 Git hooks（可选）
cd /你的项目 && bash .agent/hooks/git-hooks-setup.sh
```

## 文件清单

```
windsurf-agent/
├── .windsurfrules                         # 主规则文件（Windsurf 自动加载）
├── .windsurf/rules/                       # 上下文规则
│   ├── code-quality.md                   #   代码质量（trigger: always）
│   └── git-workflow.md                   #   Git 工作流（trigger: manual）
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
