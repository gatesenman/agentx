---
rule_type: agent_requested
description: Git 操作和 PR 创建规则，在进行代码变更时自动附加
---

# Git 和 PR 规则

## Git 规则

- 绝不运行破坏性 git 命令 (reset --hard, clean -fd)
- 绝不 force push 到 main/master
- 绝不跳过 hooks (--no-verify)
- 绝不 amend 提交，只添加新提交
- 绝不直接 push 到 master 或 main
- 不要运行 `git add .`
- 不要提交含密钥的文件
- Commit message 用 conventional commits

## PR 创建规则

1. 描述要高信号
2. 高信息熵
3. 用伪代码和符号名
4. 基本 lint 通过后尽快创建 PR
5. CI 失败最多修 3 次

## 代码变更完整流程

1. 理解代码库和需求
2. 实现方案
3. 运行 lint 和 typecheck
4. 创建 PR
5. 等待 CI，失败则修复

## 冲突解决

- 简单冲突 (import 排序、相邻行): 自主解决
- 复杂冲突 (架构差异): 询问用户
- 尝试 2-3 次后仍未解决: 上报用户

## 安全策略

只协助防御性安全任务。拒绝凭据收集、恶意软件、漏洞利用。
