# Aider 配置指南

## 概述

Aider 是开源的 AI 编程 CLI 工具，通过 `.aider.conf.yml` 配置文件和 `CONVENTIONS.md` 编码规范文件加载项目规则。

---

## 文件清单

| 文件 | 作用 | 必须 |
|------|------|------|
| `.aider.conf.yml` | Aider 配置文件（模型、编辑格式等） | 是 |
| `CONVENTIONS.md` | 编码规范文档（自动加载为只读上下文） | 是 |
| `.aiderignore` | 忽略文件列表（类似 .gitignore） | 推荐 |

---

## 安装步骤

```bash
cp agentx/aider/.aider.conf.yml /你的项目/
cp agentx/aider/CONVENTIONS.md /你的项目/
cp agentx/aider/.aiderignore /你的项目/
```

---

## 配置文件格式

### .aider.conf.yml

```yaml
# AI 模型设置
model: claude-3-5-sonnet-20241022

# 自动加载的只读文件
read:
  - CONVENTIONS.md

# Repo map 设置
map-tokens: 4096
map-refresh: auto

# 编辑格式
edit-format: diff
auto-lint: true

# 忽略文件
aiderignore: .aiderignore
```

### CONVENTIONS.md

纯 Markdown 格式，包含编码规范。Aider 会自动加载为只读上下文：

```markdown
# 编码规范

## 代码质量
...
```

### .aiderignore

与 `.gitignore` 格式相同，指定 Aider 不应读取/修改的文件：

```
node_modules/
dist/
.env
*.min.js
```

---

## 验证

```bash
cd /你的项目
aider

# 在 aider 中输入
/settings    # 查看当前配置
/read        # 查看已加载的只读文件
```

---

## 注意事项

- `.aider.conf.yml` 中的 `model` 字段需要你有对应模型的 API Key
- `read` 中引用的文件必须存在，否则 Aider 会警告
- `auto-lint: true` 需要项目有配置好的 lint 工具

---

## 参考

- [Aider 文档](https://aider.chat/docs)
- [规则系统](../规则系统.md)
