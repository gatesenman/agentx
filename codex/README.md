# OpenAI Codex CLI 智能体配置

## 安装方法

### 项目级（团队共享）
```bash
cp AGENTS.md /你的项目/
```

### 全局级（个人偏好）
```bash
mkdir -p ~/.codex
cp AGENTS.md ~/.codex/
```

### 临时覆盖
```bash
cp AGENTS.md ~/.codex/AGENTS.override.md
# 用完后删除即可恢复
```

## 文件说明

| 文件 | 用途 |
|------|------|
| `AGENTS.md` | 核心规则文件，Codex 启动时自动加载 |
| `workflows/` | 4 个工作流模板（bug修复/功能实现/重构/CI修复） |
| `scripts/` | 3 个可运行脚本（项目设置/提交检查/密钥扫描） |
| `hooks/` | Git hooks 一键安装脚本 |
| `templates/` | 配置模板（环境蓝图/PR模板/pre-commit/gitignore） |
| `DECISION-TREES.md` | 7 类完整决策树 |
| `MCP-TOOLS-REFERENCE.md` | 工具完整参考 |
| `AUTOMATIONS-REFERENCE.md` | 自动化和 Hook 参考 |

## 与其他 Codex 功能配合

- **Memory**: Codex 自动记住你的修正和偏好
- **Skills**: 封装可复用的多步骤流程
- **MCP**: 连接外部工具（GitHub、Linear、Slack 等）
- **Subagents**: 委托子任务给专门的子智能体

## 优先级顺序

```
~/.codex/AGENTS.override.md  (最高)
~/.codex/AGENTS.md
项目根/AGENTS.md
子目录/AGENTS.md              (按路径深度叠加)
```
