# Aider 智能体配置

## 安装方法

```bash
# 复制配置文件到项目根目录
cp .aider.conf.yml /你的项目/
cp CONVENTIONS.md /你的项目/
cp .aiderignore /你的项目/
```

## 文件说明

| 文件 | 用途 |
|------|------|
| `.aider.conf.yml` | Aider 运行时配置（模型/Git/编辑格式） |
| `CONVENTIONS.md` | 代码约定规则（通过 read: 自动加载） |
| `.aiderignore` | 忽略文件列表（不编辑/不读取） |
| `workflows/` | 工作流模板 |
| `scripts/` | 可运行脚本 |
| `hooks/` | Git hooks |
| `templates/` | 配置模板 |

## Aider 配置机制

### .aider.conf.yml
- 控制运行时行为：模型选择、Git 设置、输出格式
- 可放在项目根目录（项目级）或 `~/.aider.conf.yml`（全局）
- 项目级优先于全局

### CONVENTIONS.md
- 代码约定和规则文档
- 通过 `read:` 配置自动加载到每次对话
- Aider 只读取不编辑此文件
- 替代方案：在对话中用 `/read CONVENTIONS.md`

### .aiderignore
- 类似 .gitignore 语法
- 列出的文件不会被 Aider 编辑
- 保护锁文件、生成文件、敏感文件

## 等效环境变量

```bash
export AIDER_MODEL=claude-sonnet-4-20250514
export AIDER_DARK_MODE=true
export AIDER_AUTO_COMMITS=true
export AIDER_AUTO_LINT=true
```
