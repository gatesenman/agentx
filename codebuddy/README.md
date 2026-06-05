# CodeBuddy (腾讯云代码助手) 智能体配置

## 安装方法

```bash
# 复制主规则文件到项目根目录
cp CODEBUDDY.md /你的项目/

# 复制结构化规则目录
cp -r .codebuddy /你的项目/
```

## 文件说明

| 文件 | 用途 |
|------|------|
| `CODEBUDDY.md` | 主规则文件，CodeBuddy 自动加载 |
| `.codebuddy/rules/code-quality/RULE.mdc` | 代码质量规则 (alwaysApply) |
| `.codebuddy/rules/git-workflow/RULE.mdc` | Git 工作流规则 (手动触发) |
| `workflows/` | 工作流模板 |
| `scripts/` | 可运行脚本 |
| `hooks/` | Git hooks |
| `templates/` | 配置模板 |

## CodeBuddy 规则格式

### CODEBUDDY.md
- 纯 Markdown 文件，无需 frontmatter
- 放项目根目录，自动加载全部内容
- 兼容 AGENTS.md（如果没有 CODEBUDDY.md 会读取 AGENTS.md）

### .codebuddy/rules/ 结构化规则
- 每个规则一个文件夹，包含 `RULE.mdc`
- 支持 frontmatter 控制加载行为:
  - `alwaysApply: true` — 始终加载
  - `alwaysApply: false` — 根据上下文或手动触发
- 可版本控制，团队共享

## 全局规则

```bash
# 个人全局规则
~/.codebuddy/rules/*.md
# 全局记忆
~/.codebuddy/CODEBUDDY.md
```
