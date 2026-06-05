# 跨 IDE 迁移指南

> 从一个 AI 编程工具切换到另一个时，如何迁移你的规则配置。

---

## 目录

1. [迁移概述](#迁移概述)
2. [格式对照表](#格式对照表)
3. [具体迁移路径](#具体迁移路径)
4. [通用兼容方案](#通用兼容方案)
5. [多工具共存](#多工具共存)

---

## 迁移概述

### 核心思路

所有 AI 编程工具的规则本质上都是一样的——**Markdown 格式的指令文本**。区别只在于：
- 文件名不同
- 存放位置不同
- 元数据格式不同（frontmatter）
- 加载机制不同

因此迁移通常只需要：
1. 复制内容到新格式的文件
2. 调整 frontmatter（如有）
3. 放到正确的位置

### 迁移难度

| 从 → 到 | 难度 | 说明 |
|----------|------|------|
| Claude Code → Cursor | 简单 | 复制内容，改文件名 |
| Cursor → Claude Code | 简单 | 复制内容，改文件名 |
| 任意 → Codex/Copilot | 简单 | 改名为 AGENTS.md |
| 任意 → Cline | 简单 | Cline 自动识别多种格式 |
| 任意 → Aider | 中等 | 需要拆分为 conf.yml + CONVENTIONS.md |
| 任意 → Devin | 中等 | 需要拆分为多个 SKILL.md |

---

## 格式对照表

| IDE | 文件名 | 位置 | 格式 |
|-----|--------|------|------|
| Claude Code | `CLAUDE.md` | 项目根 | Markdown |
| Cursor | `.cursorrules` | 项目根 | Markdown |
| Cursor (新) | `.cursor/rules/*.mdc` | 项目根 | Markdown + YAML frontmatter |
| Windsurf | `.windsurfrules` | 项目根 | Markdown |
| Windsurf (新) | `.windsurf/rules/*.md` | 项目根 | Markdown + YAML frontmatter |
| Copilot | `AGENTS.md` | 项目根 | Markdown |
| Copilot Chat | `.github/copilot-instructions.md` | .github/ | Markdown |
| Codex | `AGENTS.md` | 项目根或 ~/.codex/ | Markdown |
| Cline | `.clinerules/` 或 `.clinerules` | 项目根 | Markdown |
| CodeBuddy | `CODEBUDDY.md` | 项目根 | Markdown |
| CodeBuddy (结构化) | `.codebuddy/rules/*/RULE.mdc` | 项目根 | Markdown + YAML |
| Augment | `.augment/rules/*.md` | 项目根 | Markdown + YAML frontmatter |
| Aider | `CONVENTIONS.md` + `.aider.conf.yml` | 项目根 | Markdown + YAML |
| Roo Code | `.roo/rules/*.md` 或 `.roorules` | 项目根 | Markdown |
| Amazon Q | `.amazonq/rules/*.md` | 项目根 | Markdown |
| Qodo | `AGENTS.md` | 项目根 | Markdown |
| Devin | `.devin/skills/*/SKILL.md` | 项目根 | Markdown + YAML frontmatter |

---

## 具体迁移路径

### Claude Code → Cursor

```bash
# 方法 1: 直接复制（快速）
cp CLAUDE.md .cursorrules

# 方法 2: 结构化（推荐）
mkdir -p .cursor/rules
# 把 CLAUDE.md 中不同章节拆分为:
# .cursor/rules/code-quality.mdc (alwaysApply: true)
# .cursor/rules/git-workflow.mdc (alwaysApply: false)
# .cursor/rules/debugging.mdc (alwaysApply: false)
```

每个 .mdc 文件加 frontmatter:
```markdown
---
description: 代码质量规则
alwaysApply: true
---

[规则内容]
```

### Cursor → Claude Code

```bash
# 合并所有规则到一个文件
cat .cursorrules > CLAUDE.md

# 如果有 .cursor/rules/ 目录:
for f in .cursor/rules/*.mdc; do
  echo -e "\n---\n" >> CLAUDE.md
  # 去掉 frontmatter 后追加内容
  sed '1,/^---$/d; 1,/^---$/d' "$f" >> CLAUDE.md
done
```

### 任意 → Cline

Cline 最友好，它自动检测:
- `.clinerules/` (原生格式)
- `.cursorrules` (Cursor 格式)
- `.windsurfrules` (Windsurf 格式)
- `AGENTS.md` (通用格式)

所以如果你已有任何一种，Cline 直接就能用。

如果要用原生格式:
```bash
mkdir .clinerules
# 按主题拆分为多个文件
cp CLAUDE.md .clinerules/01-all-rules.md
# 或拆分为:
# .clinerules/01-core.md
# .clinerules/02-code-quality.md
# .clinerules/03-git.md
```

### 任意 → Aider

Aider 需要拆分为两部分:

1. **运行时配置** → `.aider.conf.yml`:
```yaml
model: claude-sonnet-4-20250514
auto-commits: true
auto-lint: true
read:
  - CONVENTIONS.md
```

2. **规则内容** → `CONVENTIONS.md`:
```bash
# 复制规则内容
cp CLAUDE.md CONVENTIONS.md
# 或 cp .cursorrules CONVENTIONS.md
```

### 任意 → Devin Skills

Devin 需要把规则拆分为多个技能文件:

```bash
mkdir -p .devin/skills/{pr-workflow,debugging,testing,code-review}

# 每个 SKILL.md 需要 frontmatter:
```

```markdown
---
name: pr-workflow
description: PR 创建和管理流程
---

# PR 工作流

[从原规则中提取 PR 相关内容]
```

---

## 通用兼容方案

### 方案 1: AGENTS.md 作为统一入口

`AGENTS.md` 被最多工具支持:
- Codex ✅ (原生)
- Copilot ✅ (原生)
- Qodo ✅ (原生)
- Cline ✅ (自动检测)
- CodeBuddy ✅ (兼容)
- Augment ✅ (兼容)

如果你想只维护一个文件:
```bash
# 只保留 AGENTS.md
cp CLAUDE.md AGENTS.md
# 大部分工具都能读取
```

### 方案 2: 多文件共存

如果团队用不同工具:
```
项目根/
├── CLAUDE.md          → Claude Code 用户读取
├── .cursorrules       → Cursor 用户读取 (可以是 symlink)
├── AGENTS.md          → Codex/Copilot/Qodo 用户读取
└── .windsurfrules     → Windsurf 用户读取
```

用 symlink 避免重复维护:
```bash
# 以 AGENTS.md 为主，其他 symlink 指向它
ln -s AGENTS.md CLAUDE.md
ln -s AGENTS.md .cursorrules
ln -s AGENTS.md .windsurfrules
```

### 方案 3: 脚本同步

```bash
#!/bin/bash
# sync-rules.sh — 从 AGENTS.md 同步到所有格式

SOURCE="AGENTS.md"

# Claude Code
cp "$SOURCE" CLAUDE.md

# Cursor
cp "$SOURCE" .cursorrules

# Windsurf
cp "$SOURCE" .windsurfrules

# CodeBuddy
cp "$SOURCE" CODEBUDDY.md

echo "同步完成"
```

---

## 多工具共存

### 文件不冲突

好消息是各工具的文件名不同，所以可以全部共存:

```
项目根/
├── CLAUDE.md                   # Claude Code
├── CLAUDE.local.md             # Claude Code (个人)
├── .cursorrules                # Cursor
├── .cursor/rules/*.mdc         # Cursor (结构化)
├── .windsurfrules              # Windsurf
├── .windsurf/rules/*.md        # Windsurf (结构化)
├── AGENTS.md                   # Codex/Copilot/Qodo
├── .github/copilot-instructions.md  # Copilot Chat
├── .clinerules/                # Cline
├── CODEBUDDY.md                # CodeBuddy
├── .codebuddy/rules/           # CodeBuddy (结构化)
├── .augment/rules/             # Augment
├── .aider.conf.yml             # Aider
├── CONVENTIONS.md              # Aider
├── .aiderignore                # Aider
├── .roo/rules/                 # Roo Code
├── .roorules                   # Roo Code (单文件)
├── .amazonq/rules/             # Amazon Q
├── .devin/skills/              # Devin
└── .gitignore                  # 忽略个人文件
```

### .gitignore 建议

```gitignore
# 个人偏好文件（不提交）
CLAUDE.local.md

# Aider 历史
.aider.chat.history.md
.aider.tags.cache.v3/
```

---

## 下一步

- [使用教程](./USAGE-GUIDE.md) — 每个 IDE 的详细设置步骤
- [最佳实践](./BEST-PRACTICES.md) — 高效使用建议
- [FAQ](./FAQ.md) — 常见问题
