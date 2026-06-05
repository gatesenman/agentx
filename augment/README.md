# Augment Code 智能体配置

## 安装方法

### 工作区规则（项目级）
```bash
cp -r .augment /你的项目/
```

### 用户规则（全局）
```bash
cp .augment/rules/*.md ~/.augment/rules/
```

## 文件说明

| 文件 | 用途 |
|------|------|
| `.augment/rules/01-core-rules.md` | 核心规则 (always_apply) |
| `.augment/rules/02-git-workflow.md` | Git 规则 (agent_requested) |
| `workflows/` | 工作流模板 |
| `scripts/` | 可运行脚本 |
| `hooks/` | Git hooks |
| `templates/` | 配置模板 |

## Augment 规则类型

| 类型 | frontmatter | 行为 |
|------|-------------|------|
| Always | `rule_type: always_apply` | 每次对话都加载 |
| Auto | `rule_type: agent_requested` | Agent 根据 description 自动判断是否需要 |
| Manual | `rule_type: manual` | 需要用 @ 手动附加（仅 IDE） |

## 兼容性

Augment 也自动检测:
- `CLAUDE.md` (Claude Code 格式)
- `AGENTS.md` (跨工具标准格式)
- `.augment-guidelines` (旧格式)

## 优先级

```
--rules 参数指定     (最高)
CLAUDE.md
AGENTS.md
.augment-guidelines
.augment/rules/     (工作区)
~/.augment/rules/   (用户全局，最低)
```
