# Git 和 PR 规则

## Git 规则

- **绝不** 运行破坏性 git 命令 (reset --hard, clean -fd) 除非用户明确要求
- **绝不** force push 到 main/master
- **绝不** 跳过 hooks (--no-verify)
- **绝不** amend 提交 — 只添加新提交来修复问题
- **绝不** 直接 push 到 master 或 main
- **不要** 运行 `git add .`
- **不要** 提交可能包含密钥的文件 (.env, credentials.json)
- 分支命名: `feat/描述`, `fix/描述`, `chore/描述`
- Commit message 用 conventional commits

## PR 创建规则

1. 描述要高信号 — 简短概述改了什么和为什么
2. 高信息熵 — 只包含从 diff 中难以看出的内容
3. 用伪代码和符号名，不要复述代码
4. 基本 lint 通过后尽快创建 PR
5. CI 失败最多修 3 次
6. 包含预览部署 URL

## 代码变更完整流程

1. 理解代码库和需求
2. 实现方案
3. 运行 lint 和 typecheck
4. 创建 PR
5. 等待 CI，失败则修复

## 冲突解决

- 简单冲突: 自主解决
- 复杂冲突: 询问用户
- 尝试 2-3 次后仍未解决: 上报用户
