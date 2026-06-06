# AgentX — 多 IDE AI 智能体完整运行基础设施

> 完整的 AI 编程智能体规则、工作流、技能、记忆系统、工具链、自动化配置。
> 按 IDE 分类，自包含，直接放进项目即可使用。
> 复刻自 Devin AI 的完整工作规则和运行时行为。

## 支持的 IDE / AI 工具

| 目录 | IDE / 工具 | 核心文件 | 安装方式 |
|------|-----------|---------|---------|
| `claude-code/` | Claude Code (Anthropic) | `CLAUDE.md` | 复制到项目根目录 |
| `cursor/` | Cursor IDE | `.cursorrules` + `.cursor/rules/` | 复制到项目根目录 |
| `windsurf/` | Windsurf (Cascade) | `.windsurfrules` + `.windsurf/rules/` | 复制到项目根目录 |
| `copilot/` | GitHub Copilot | `AGENTS.md` + `.github/` | 复制到项目根目录 |
| `codex/` | OpenAI Codex CLI | `AGENTS.md` | 复制到项目根目录或 `~/.codex/` |
| `devin/` | Devin 平台 | `.devin/skills/` | 复制到仓库，git push |
| `cline/` | Cline (VS Code) | `.clinerules/` | 复制到项目根目录 |
| `codebuddy/` | CodeBuddy (腾讯云) | `CODEBUDDY.md` + `.codebuddy/rules/` | 复制到项目根目录 |
| `augment/` | Augment Code | `.augment/rules/` | 复制到项目根目录 |
| `aider/` | Aider | `.aider.conf.yml` + `CONVENTIONS.md` | 复制到项目根目录 |
| `roo-code/` | Roo Code | `.roo/rules/` | 复制到项目根目录 |
| `amazon-q/` | Amazon Q Developer | `.amazonq/rules/` | 复制到项目根目录 |
| `qodo/` | Qodo (原 Qodo Gen) | `AGENTS.md` + `.qodo/agents/` | 复制到项目根目录 |

## 快速使用

```bash
# 克隆本仓库
git clone https://github.com/gaosichun888/agentx.git

# 选择你使用的 IDE，复制对应文件到你的项目
# 例: 使用 Claude Code
cp agentx/claude-code/CLAUDE.md /你的项目/

# 例: 使用 Cursor
cp agentx/cursor/.cursorrules /你的项目/
cp -r agentx/cursor/.cursor /你的项目/

# 例: 使用 Windsurf
cp agentx/windsurf/.windsurfrules /你的项目/
cp -r agentx/windsurf/.windsurf /你的项目/

# 例: 使用 GitHub Copilot / Codex
cp agentx/copilot/AGENTS.md /你的项目/

# 例: 使用 Cline
cp -r agentx/cline/.clinerules /你的项目/

# 例: 使用 CodeBuddy
cp agentx/codebuddy/CODEBUDDY.md /你的项目/
cp -r agentx/codebuddy/.codebuddy /你的项目/

# 安装 Git hooks（可选，所有 IDE 通用）
cd /你的项目 && bash agentx/claude-code/hooks/install-hooks.sh
```

## 每个 IDE 包含的完整内容

每个 IDE 目录都是**自包含**的，包含完整的智能体运行基础设施:

```
<ide>/
├── 核心规则文件                           # IDE 自动加载的主规则
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
│   ├── setup-project.sh                  #   项目自动设置 (274行)
│   └── verify-no-secrets.sh              #   10类密钥深度扫描 (212行)
│
├── templates/                             # 配置模板
│   ├── environment.yaml                  #   Devin 环境蓝图模板
│   ├── pr-template.md                    #   PR 描述模板
│   ├── pre-commit-config.yaml            #   .pre-commit-config.yaml 模板
│   └── gitignore.template                #   .gitignore 安全模板
│
├── MCP-TOOLS-REFERENCE.md                 # 50+ 工具完整参考 (445行)
├── MEMORY-SYSTEM.md                       # 7层记忆架构参考 (303行)
├── SKILLS-REFERENCE.md                    # 技能系统完整参考 (255行)
├── DECISION-TREES.md                      # 10类完整决策树 (361行)
├── AUTOMATIONS-REFERENCE.md               # 自动化和 Hook 配置参考 (321行)
├── TROUBLESHOOTING.md                     # 常见问题排查指南
├── PROMPT-PATTERNS.md                     # 提示词模式和最佳实践
├── TOOL-CHAINS.md                         # 端到端工具链编排参考
└── README.md                              # IDE 专属安装说明
```

## 规则覆盖范围 (15 个规则域)

| 规则域 | 说明 |
|--------|------|
| 核心原则 | 坚持性、彻底性、独立性、主动推断意图 |
| 代码质量 | 最小化编辑、遵循约定、类型安全、不用 Any |
| 代码注释 | 默认不注释、不注释 diff、匹配风格 |
| Git 规则 | 分支命名、提交规范、13 条禁止操作 |
| PR 工作流 | 创建、描述模板、CI 修复、draft PR、多 PR |
| 任务管理 | TODO 清单、状态跟踪、不丢弃任务 |
| 仓库设置 | 按 README、Monorepo、多语言、环境检测 |
| 调试流程 | 复现→定位→根因→修复→验证 |
| 测试流程 | 黄金路径、录屏证据、端到端验证 |
| 安全策略 | 密钥保护、敏感文件检查、防御性安全 |
| 通信规则 | 简洁、高信号、链接优先 |
| 凭据管理 | 三选项协议、批量请求 |
| 错误处理 | 基础设施 vs 任务级分类、重试策略 |
| 冲突解决 | 简单自主、复杂上报、进度更新 |
| 专业标准 | 技术准确性优先、严格平等 |

## 工具链和基础设施

| 类别 | 包含内容 |
|------|---------|
| 工作流 | 4 个完整 Playbook，每个 6-8 步，含命令、决策分支、模板 |
| MCP 工具 | 50+ 工具完整文档: 文件操作、Shell、Git、浏览器、部署、知识管理 |
| 记忆系统 | 7 层架构: 会话→知识→技能→Playbook→蓝图→密钥→浏览器 |
| 技能系统 | 8 个内置技能 + 自定义技能模板 + 执行规则 |
| 决策引擎 | 10 类决策树: 任务路由、工具选择、并行/串行、错误处理、Git、PR、通信 |
| 自动化 | 4 个事件驱动自动化 + 3 个 Git Hooks + 定时任务 |
| 脚本 | 项目自动设置（检测类型/包管理器/Monorepo）+ 密钥深度扫描 |
| 模板 | 环境蓝图、PR 描述、pre-commit 配置、.gitignore |
| 排查指南 | 环境问题、CI 失败、性能、Git 冲突的系统化排查 |
| 提示词模式 | 10 类高效提示词模式 + 反模式 |
| 工具链编排 | 30+ 场景的端到端工具链调用序列 |

## 跨工具兼容性

| 工具 | 原生格式 | 也支持读取 |
|------|---------|-----------|
| Codex | `AGENTS.md` | — |
| Cline | `.clinerules/` | `.cursorrules`, `.windsurfrules`, `AGENTS.md` |
| CodeBuddy | `CODEBUDDY.md` | `AGENTS.md` |
| Augment | `.augment/rules/` | `CLAUDE.md`, `AGENTS.md` |
| Qodo | `AGENTS.md` | — |
| Roo Code | `.roo/rules/` | — |

如果你的项目同时有多个 AI 工具使用者，可以只放一个 `AGENTS.md`，大部分工具都能识别。

## 文档

| 文档 | 内容 |
|------|------|
| `docs/USAGE-GUIDE.md` | 13 个 IDE 的完整使用教程 |
| `docs/CUSTOMIZATION.md` | 规则自定义指南 |
| `docs/WORKFLOWS-GUIDE.md` | 工作流详细使用说明 |
| `docs/MIGRATION.md` | 跨 IDE 迁移指南 |
| `docs/FAQ.md` | 常见问题解答 |
| `docs/BEST-PRACTICES.md` | 最佳实践和反模式 |

## 许可

MIT
