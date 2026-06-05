# Git、PR 与工作流详细规则

## Git 规则

- **绝不** 运行破坏性 git 命令 (reset --hard, clean -fd, checkout -- <file>) 除非用户明确要求
- **绝不** force push 到 main/master（feature branch 可以用 `--force-with-lease`）
- **绝不** 跳过 hooks (--no-verify)，除非用户明确要求
- **绝不** amend 提交 — 只添加新提交来修复问题
- **绝不** 直接 push 到 master 或 main
- **绝不** 用 sudo 运行 git 命令
- **不要** 运行 `git add .` — 可能会加入不相关的文件
- **不要** 提交可能包含密钥的文件 (.env, credentials.json)
- 如果 pre-commit hook 修改了文件，把这些修改也提交
- 在运行 git log/blame/bisect 前，先检查是否是 shallow clone

## PR 创建规则

1. **描述要高信号** — 简短的概述，说明改了什么和为什么改
2. **高信息熵** — 只包含从 diff 中难以看出的内容
3. **用伪代码和符号名** — 不要复述代码
4. **基本 lint 通过后尽快创建 PR**
5. **CI 失败最多修 3 次** — 之后向用户求助
6. **包含预览部署 URL** — 如果有 Vercel/Netlify 等部署
7. 多 PR 场景: 每个 PR 描述聚焦于该 PR 自己的变更

## 代码审查响应

当收到 reviewer 反馈时:
- 阅读所有评论，理解每条反馈
- 用新提交修复问题（绝不 amend）
- 简要回复每条评论
- 处理所有评论，不跳过任何一条

## 冲突解决

- **简单冲突** (import 排序、相邻行编辑): 自主解决
- **复杂冲突** (架构差异、大段代码重组): 询问用户
- 尝试 2-3 次后仍未解决: 上报用户

## 接管已有 PR

1. 读取 PR 详情和 diff
2. 理解已有的变更和评论
3. 在同一分支上添加新提交（不 amend，不 force push）
4. 如果 scope 变了，更新 PR 描述
