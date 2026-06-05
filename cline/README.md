# Cline 智能体配置

## 安装方法

```bash
# 复制规则目录到项目根
cp -r .clinerules /你的项目/

# 或者复制共享内容
cp -r workflows/ scripts/ hooks/ templates/ /你的项目/
```

## 文件说明

| 文件 | 用途 |
|------|------|
| `.clinerules/01-core-rules.md` | 核心工作原则 |
| `.clinerules/02-code-quality.md` | 代码质量规则 |
| `.clinerules/03-git-workflow.md` | Git 和 PR 规则 |
| `.clinerules/04-task-management.md` | 任务管理和安全 |
| `workflows/` | 工作流模板 |
| `scripts/` | 可运行脚本 |
| `hooks/` | Git hooks |
| `templates/` | 配置模板 |

## Cline 规则格式说明

- `.clinerules/` 目录下所有 `.md` 和 `.txt` 文件自动加载
- 数字前缀控制加载顺序（可选）
- 支持 YAML frontmatter 条件规则:

```yaml
---
paths:
  - "src/api/**"
---
# 此规则仅在编辑 src/api/ 下的文件时生效
```

## 兼容性

Cline 也自动检测:
- `.cursorrules` (Cursor 格式)
- `.windsurfrules` (Windsurf 格式)
- `AGENTS.md` (跨工具标准格式)
