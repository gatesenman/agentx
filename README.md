# AgentMD — 多 IDE 智能体规则配置

> 完整的 AI 编程助手规则文件，按 IDE 分类，直接放进项目即可使用。

## 支持的 IDE

| 目录 | IDE | 核心文件 | 安装方式 |
|------|-----|---------|---------|
| `claude-code/` | Claude Code (Anthropic) | `CLAUDE.md` | 复制到项目根目录 |
| `cursor/` | Cursor IDE | `.cursorrules` + `.cursor/rules/` | 复制到项目根目录 |
| `windsurf/` | Windsurf (Cascade) | `.windsurfrules` + `.windsurf/rules/` | 复制到项目根目录 |
| `copilot/` | GitHub Copilot / Codex | `AGENTS.md` + `.github/` | 复制到项目根目录 |
| `devin/` | Devin 平台 | `.devin/skills/` | 复制到仓库，git push |

## 快速使用

```bash
# 克隆本仓库
git clone https://github.com/gaosichun888/agentmd.git

# 选择你使用的 IDE，复制对应文件到你的项目
# 例: 使用 Cursor
cp agentmd/cursor/.cursorrules /你的项目/
cp -r agentmd/cursor/.cursor /你的项目/

# 例: 使用 Claude Code
cp agentmd/claude-code/CLAUDE.md /你的项目/

# 例: 使用 GitHub Copilot
cp agentmd/copilot/AGENTS.md /你的项目/
cp -r agentmd/copilot/.github /你的项目/
```

## 每个 IDE 包含的内容

每个 IDE 目录都是**自包含**的，包含:

- **核心规则文件** — IDE 自动加载的主规则
- **workflows/** — 4 个完整工作流 (Bug修复 / 功能实现 / 重构 / CI修复)
- **scripts/** — 3 个可运行脚本 (项目设置 / 提交检查 / 密钥扫描)
- **hooks/** — Git hooks 一键安装脚本 (pre-commit / commit-msg / pre-push)
- **templates/** — 4 个配置模板 (环境蓝图 / PR模板 / pre-commit / gitignore)
- **DECISION-TREES.md** — 7 类完整决策树
- **MCP-TOOLS-REFERENCE.md** — 50+ 工具完整参考
- **AUTOMATIONS-REFERENCE.md** — 自动化和 Hook 配置参考

## 规则覆盖范围

- 核心原则 (坚持性、彻底性、独立性)
- 代码质量 (最小化编辑、遵循约定、类型安全)
- Git 规则 (分支命名、提交规范、禁止操作)
- PR 工作流 (创建、描述、CI 修复)
- 调试流程 (复现→定位→根因→修复→验证)
- 仓库设置 (按 README 安装、环境配置)
- 测试流程 (黄金路径、验证命令)
- 安全策略 (密钥保护、敏感文件检查)
- 通信规则 (简洁、高信号)
- 凭据管理 (三选项协议)
- 错误处理 (分类、重试、上报)

## 许可

MIT
