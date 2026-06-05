# Roo Code 智能体配置

## 安装方法

```bash
# 推荐：目录格式
cp -r .roo /你的项目/

# 或者：单文件格式
cp .roorules /你的项目/
```

## 文件说明

| 文件 | 用途 |
|------|------|
| `.roo/rules/01-core-rules.md` | 核心规则（所有模式） |
| `.roo/rules/02-git-workflow.md` | Git 工作流规则（所有模式） |
| `.roorules` | 备用单文件格式 |
| `workflows/` | 工作流模板 |
| `scripts/` | 可运行脚本 |
| `hooks/` | Git hooks |
| `templates/` | 配置模板 |

## Roo Code 规则格式

### 目录格式 `.roo/rules/`（推荐）
- 所有 `.md` 文件自动加载
- 数字前缀控制顺序
- 支持模式特定规则：`.roo/rules-code/`、`.roo/rules-docs/`

### 单文件格式 `.roorules`
- 简单场景使用
- 也支持模式特定：`.roorules-code`

### 全局规则
```
~/.roo/rules/           — 所有模式
~/.roo/rules-code/      — Code 模式专用
~/.roo/rules-docs/      — Docs 模式专用
```

## 优先级

```
工作区规则 > 全局规则
目录格式 > 单文件格式
```

## 模式特定规则

Roo Code 有多种模式，可以为每种模式设置不同规则:
- `rules-code/` — Code 模式（写代码）
- `rules-architect/` — Architect 模式（设计）
- `rules-docs/` — Docs 模式（文档）
- `rules-ask/` — Ask 模式（问答）
