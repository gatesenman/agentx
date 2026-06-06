# AgentX Wiki — 多 IDE AI 智能体配置百科

> 本 Wiki 提供 AgentX 项目的完整说明文档，涵盖架构设计、安装配置、13 个 IDE 的详细使用指南、工作流系统、MCP 工具链、记忆系统、安全策略等。

---

## 📖 文档导航

### 基础入门

| 文档 | 说明 |
|------|------|
| [快速开始](快速开始.md) | 5 分钟上手，一键安装到你的项目 |
| [项目架构](项目架构.md) | 整体架构设计、目录结构、设计理念 |
| [常见问题](常见问题.md) | 安装/配置/使用 FAQ |

### IDE 配置指南（13 个 IDE）

| IDE | 指南链接 | 核心文件 |
|-----|---------|---------|
| Claude Code | [配置指南](IDE配置指南/Claude-Code.md) | `CLAUDE.md` |
| Cursor | [配置指南](IDE配置指南/Cursor.md) | `.cursorrules` + `.cursor/rules/` |
| Windsurf | [配置指南](IDE配置指南/Windsurf.md) | `.windsurfrules` + `.windsurf/rules/` |
| GitHub Copilot | [配置指南](IDE配置指南/Copilot.md) | `AGENTS.md` + `.github/` |
| OpenAI Codex | [配置指南](IDE配置指南/Codex.md) | `AGENTS.md` |
| Cline | [配置指南](IDE配置指南/Cline.md) | `.clinerules/` |
| CodeBuddy | [配置指南](IDE配置指南/CodeBuddy.md) | `CODEBUDDY.md` + `.codebuddy/rules/` |
| Augment | [配置指南](IDE配置指南/Augment.md) | `.augment/rules/` |
| Aider | [配置指南](IDE配置指南/Aider.md) | `.aider.conf.yml` + `CONVENTIONS.md` |
| Roo Code | [配置指南](IDE配置指南/Roo-Code.md) | `.roo/rules/` + `.roorules` |
| Amazon Q | [配置指南](IDE配置指南/Amazon-Q.md) | `.amazonq/rules/` |
| Qodo | [配置指南](IDE配置指南/Qodo.md) | `AGENTS.md` + `.qodo/agents/` |
| Devin | [配置指南](IDE配置指南/Devin.md) | `.devin/skills/` |

### 核心系统

| 文档 | 说明 |
|------|------|
| [规则系统](规则系统.md) | 规则格式标准、优先级机制、自定义方法 |
| [工作流系统](工作流系统.md) | 4 个 Playbook 工作流详解、执行流程图 |
| [MCP 工具链](MCP工具链.md) | 50+ 工具分类、使用场景、配置参考 |
| [记忆系统](记忆系统.md) | 7 层记忆架构、知识管理、跨会话机制 |

### 工程基础设施

| 文档 | 说明 |
|------|------|
| [Git Hooks 自动化](Git-Hooks自动化.md) | hooks 安装、配置、自定义、故障排查 |
| [安全策略](安全策略.md) | 密钥检测、安全扫描、最佳实践 |

---

## 项目概览

**AgentX** 是一套完整的 AI 编程智能体配置包，覆盖 13 个主流 IDE/AI 工具，提供统一的：

- **规则系统** — 代码质量、Git 工作流、任务管理、安全策略
- **工作流系统** — Bug 修复、功能实现、代码重构、CI 修复 4 大标准化工作流
- **MCP 工具链** — 50+ 工具的完整参考，涵盖文件操作、搜索、Shell、浏览器、部署等
- **记忆系统** — 7 层记忆架构（会话 → 知识 → 技能 → Playbook → 蓝图 → 密钥 → 浏览器）
- **Git Hooks** — pre-commit（密钥检测/lint/类型检查）、commit-msg（Conventional Commits）、pre-push（分支保护）
- **安全扫描** — 10 类密钥自动检测、禁止文件提交、大文件拦截

所有内容中文编写，按各 IDE 官方规范格式化，零外部依赖，复制即用。

---

## 快速链接

- **仓库地址**: https://github.com/gaosichun888/agentx
- **文件总数**: 348 个
- **代码总行数**: ~72,000 行
- **支持 IDE**: 13 个
