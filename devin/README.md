# Devin 平台智能体完整配置包

## 快速安装

```bash
# 1. 解压
unzip devin-agent.zip

# 2. 复制 .devin/ 到仓库
cp -r devin-agent/.devin/ /你的仓库/

# 3. 复制参考文件
mkdir -p /你的仓库/.agent
cp -r devin-agent/workflows /你的仓库/.agent/
cp -r devin-agent/scripts /你的仓库/.agent/
cp -r devin-agent/hooks /你的仓库/.agent/
cp -r devin-agent/templates /你的仓库/.agent/
cp devin-agent/DECISION-TREES.md /你的仓库/.agent/
cp devin-agent/MCP-TOOLS-REFERENCE.md /你的仓库/.agent/
cp devin-agent/AUTOMATIONS-REFERENCE.md /你的仓库/.agent/

# 4. 复制自动化和环境配置参考
cp -r devin-agent/automations /你的仓库/.agent/
cp -r devin-agent/knowledge /你的仓库/.agent/
cp -r devin-agent/environment /你的仓库/.agent/
cp -r devin-agent/mcp /你的仓库/.agent/

# 5. 提交到 Git
cd /你的仓库
git add .devin/ .agent/
git commit -m "chore: 添加 Devin 智能体配置"
git push

# 6. 安装 Git hooks（可选）
bash .agent/hooks/git-hooks-setup.sh
```

## 文件清单

```
devin-agent/
├── .devin/skills/                         # 8 个 Devin 技能（自动发现）
│   ├── pr-workflow/SKILL.md              #   PR 创建工作流
│   ├── repo-setup/SKILL.md              #   仓库设置工作流
│   ├── testing/SKILL.md                 #   测试与录屏
│   ├── debugging/SKILL.md               #   调试工作流
│   ├── code-review/SKILL.md             #   代码审查响应
│   ├── deployment/SKILL.md              #   部署工作流
│   ├── child-sessions/SKILL.md          #   子会话管理
│   └── data-analysis/SKILL.md           #   数据分析
├── README.md
│
├── workflows/                             # 4 个完整工作流
├── scripts/                               # 3 个可运行脚本
├── hooks/                                 # Git hooks 安装
├── templates/                             # 4 个配置模板
├── automations/                           # 自动化配置参考
├── knowledge/                             # 知识库配置参考
├── environment/                           # 环境蓝图参考
├── mcp/                                   # MCP 工具配置参考
│
├── DECISION-TREES.md                      # 7 类决策树
├── MCP-TOOLS-REFERENCE.md                 # 50+ 工具参考
└── AUTOMATIONS-REFERENCE.md               # 自动化和 Hook 参考
```
