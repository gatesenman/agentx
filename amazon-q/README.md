# Amazon Q Developer 智能体配置

## 安装方法

```bash
# 复制规则目录到项目根
cp -r .amazonq /你的项目/
```

## 文件说明

| 文件 | 用途 |
|------|------|
| `.amazonq/rules/01-core-rules.md` | 核心工作规则 |
| `.amazonq/rules/02-git-workflow.md` | Git 和 PR 规则 |
| `workflows/` | 工作流模板 |
| `scripts/` | 可运行脚本 |
| `hooks/` | Git hooks |
| `templates/` | 配置模板 |

## Amazon Q 规则格式

### 项目规则
- 放在 `{{project-root}}/.amazonq/rules/` 目录
- 必须是 Markdown 文件 (`.md`)
- 自动作为上下文加载到所有对话
- 可以创建多个规则文件

### 创建方式
1. 直接在文件系统创建文件
2. 或通过 Amazon Q 聊天界面创建

### 最佳实践
- 每个规则文件聚焦一个主题
- 用清晰的标题和结构
- 包含具体的命令示例
- 规则文件可以随项目版本控制
