# Claude Code 配置指南

## 概述

Claude Code 是 Anthropic 推出的 AI 编程助手，通过 CLI 或 VS Code 扩展使用。规则通过项目根目录的 `CLAUDE.md` 文件加载。

---

## 文件清单

| 文件 | 作用 | 必须 |
|------|------|------|
| `CLAUDE.md` | 主规则文件 | 是 |
| `CLAUDE.local.md` | 本地覆盖规则（不提交到 Git） | 否 |

---

## 安装步骤

```bash
# 从 AgentX 复制
cp agentx/claude-code/CLAUDE.md /你的项目/
cp agentx/claude-code/CLAUDE.local.md /你的项目/

# CLAUDE.local.md 通常不提交到 Git
echo "CLAUDE.local.md" >> /你的项目/.gitignore
```

---

## 规则格式

Claude Code 使用纯 Markdown 格式，无需 frontmatter：

```markdown
# 项目规则

## 核心原则
- 持续性：遇到错误不放弃，尝试所有合理方案
- 独立性：只在必要时才请求帮助
...
```

### 规则优先级

1. `CLAUDE.local.md`（本地规则，最高优先级）
2. `CLAUDE.md`（项目规则）
3. Claude Code 全局设置

### CLAUDE.local.md 用途

存放个人偏好和本地路径等不适合提交到 Git 的内容：

```markdown
# 本地开发配置

## 环境
- 本机 Python 版本: 3.12
- 本机 Node 版本: 20

## 个人偏好
- 我喜欢详细的中文注释
- 测试时使用端口 3001
```

---

## 验证

```bash
# 1. 确认文件存在
ls -la CLAUDE.md

# 2. 启动 Claude Code
claude

# 3. 输入测试问题
# "你的 Git 提交规则是什么？"
# 应回答: 使用 Conventional Commits 格式...
```

---

## 最佳实践

- `CLAUDE.md` 保持在 500 行以内，过长会降低规则执行效果
- 把最重要的规则放在文件开头
- 使用清晰的 Markdown 标题层级
- 定期更新规则，删除过时内容

---

## 参考

- [Claude Code 官方文档](https://docs.anthropic.com/claude-code)
- [规则系统](../规则系统.md)
