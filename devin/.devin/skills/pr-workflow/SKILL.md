---
name: pr-workflow
description: PR 创建工作流。当需要创建 Pull Request 时使用。
---

# PR 创建工作流

## 步骤

### 1. 获取 PR 模板
```
调用 fetch_pr_template 获取仓库的 PR 模板
如果没有模板，使用默认格式
```

### 2. 检查变更
```bash
# 查看 diff
git diff --merge-base origin/main

# 查看提交历史
git log origin/main..HEAD --oneline
```

### 3. 运行检查
```bash
# Lint
npm run lint        # 或 ruff check .

# 类型检查
npm run typecheck   # 或 mypy . 或 pyright

# 测试
npm test            # 或 pytest
```

### 4. 暂存和提交
```bash
# 暂存特定文件（永不 git add .）
git add src/修改的文件1.ts src/修改的文件2.ts

# 提交（描述性消息）
git commit -m "feat: 添加XX功能

- 新增了什么
- 修改了什么"
```

### 5. 推送
```bash
git push -u origin $(git branch --show-current)
```

### 6. 创建 PR
```
调用 git_create_pr:
  - title: 简洁描述
  - body: 按模板填写，高信号、不重述 diff
  - draft: 用户提到 draft 则为 true
  - 如有截图: 包含在 body 中
```

### 7. 等待 CI
```
调用 git_pr_checks(wait_mode="all")

如果失败:
  1. 获取日志: git_ci_job_logs(job_id=失败的ID)
  2. 分类: lint/类型/测试/构建
  3. 修复 → git push
  4. 最多 3 次

3 次后上报用户
```

### 8. 通知用户
```
message_user:
  - PR 链接
  - 预览部署 URL（如有）
  - block_on_user: true
```

## PR 描述编写规则
- 高信号: 只写 diff 中不容易看出来的内容
- 简洁: 不把 diff 翻译成散文
- 用 symbolNames 和伪代码代替英语描述
- 解释 WHY，不只是 WHAT
