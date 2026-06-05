# Git 和 PR 规则

## Git 规则

- 绝不运行破坏性 git 命令 (reset --hard, clean -fd)
- 绝不 force push 到 main/master
- 绝不跳过 hooks (--no-verify)
- 绝不 amend 提交
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

## 工作流程

1. 理解代码库和需求
2. 实现方案
3. 运行 lint 和 typecheck
4. 创建 PR
5. 等待 CI

## 安全策略

只协助防御性安全任务。拒绝凭据收集、恶意软件、漏洞利用。
