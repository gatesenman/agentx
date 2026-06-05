---
trigger: manual
---

# Git 工作流规则

## 分支: `devin/$(date +%s)-描述名`
## 提交: 暂存特定文件，描述性消息，永不 amend，永不 --no-verify
## 禁止: reset --hard, force push main, sudo git, 提交密钥
## Shallow Clone: 操作前检查 → 是 shallow 就先 unshallow

## PR 流程
1. lint + typecheck
2. 暂存特定文件 + 提交
3. push + 创建 PR（高信号描述）
4. 等 CI → 失败修最多 3 次

## CI 失败修复
1. 查失败日志
2. 分类: lint/类型/测试/构建/依赖
3. 修根因（不改测试、不用 any）
4. 无证据不声称 flaky 或预存在
5. 3 次后上报用户

## 冲突解决
- 简单（import、相邻行）→ 自主解决
- 复杂（架构差异）→ 问用户
- 2-3 次失败 → 上报
