# Cursor 智能体完整配置包

## 快速安装

```bash
# 1. 解压
unzip cursor-agent.zip

# 2. 复制到项目
cp cursor-agent/.cursorrules /你的项目/
cp -r cursor-agent/.cursor/ /你的项目/

# 3. 复制参考文件
mkdir -p /你的项目/.agent
cp -r cursor-agent/workflows /你的项目/.agent/
cp -r cursor-agent/scripts /你的项目/.agent/
cp -r cursor-agent/hooks /你的项目/.agent/
cp -r cursor-agent/templates /你的项目/.agent/
cp cursor-agent/DECISION-TREES.md /你的项目/.agent/
cp cursor-agent/MCP-TOOLS-REFERENCE.md /你的项目/.agent/
cp cursor-agent/AUTOMATIONS-REFERENCE.md /你的项目/.agent/

# 4. 安装 Git hooks（可选）
cd /你的项目 && bash .agent/hooks/git-hooks-setup.sh
```

## 文件清单

```
cursor-agent/
├── .cursorrules                           # 主规则文件（Cursor 自动加载）
├── .cursor/rules/                         # 上下文规则
│   ├── code-quality.mdc                  #   代码质量（alwaysApply: true）
│   ├── git-workflow.mdc                  #   Git/PR 工作流
│   ├── debugging.mdc                     #   调试规则
│   ├── repo-setup.mdc                    #   仓库设置规则
│   └── testing.mdc                       #   测试规则
├── README.md
│
├── workflows/                             # 4 个完整工作流
│   ├── PLAYBOOK-bug-fix.md
│   ├── PLAYBOOK-feature-implementation.md
│   ├── PLAYBOOK-refactoring.md
│   └── PLAYBOOK-ci-fix.md
├── scripts/                               # 3 个可运行脚本
│   ├── setup-project.sh
│   ├── pre-commit-check.sh
│   └── verify-no-secrets.sh
├── hooks/                                 # Git hooks 安装
│   └── git-hooks-setup.sh
├── templates/                             # 4 个配置模板
│   ├── environment.yaml
│   ├── pr-template.md
│   ├── pre-commit-config.yaml
│   └── gitignore-template
│
├── DECISION-TREES.md                      # 7 类决策树
├── MCP-TOOLS-REFERENCE.md                 # 50+ 工具参考
└── AUTOMATIONS-REFERENCE.md               # 自动化配置参考
```

## Cursor 规则加载机制

- `.cursorrules` — 全局规则，启动时自动加载
- `.cursor/rules/*.mdc` — 上下文规则:
  - `alwaysApply: true` → 始终生效（如 code-quality）
  - `alwaysApply: false` → 匹配 description 时触发（如 debugging、testing）
  - `globs: ["**/*.py"]` → 匹配文件类型时触发
