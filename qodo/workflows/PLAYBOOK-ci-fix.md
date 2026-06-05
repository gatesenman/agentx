# CI 修复工作流 (Playbook)

## 触发条件
- CI 检查失败
- 用户说"CI 挂了"、"流水线失败了"
- 系统通知 CI 失败

---

## 完整步骤

### 第1步: 获取失败信息

```bash
# 通过工具获取
git_pr_checks(repo, pull_number, wait_mode="none")
# → 获取失败的 job 列表和 job_id

git_ci_job_logs(repo, job_id)
# → 获取详细失败日志
```

**关键信息提取**:
- 哪个 job 失败了？(lint / test / build / deploy)
- 失败的错误信息是什么？
- 是哪个文件/哪行代码导致的？
- 是本次变更引入的还是已有问题？

---

### 第2步: 分类和诊断

```
CI 失败类型:
│
├── Lint/Format 失败
│   ├── ESLint 错误 → 可自动修复
│   ├── Prettier 格式 → 可自动修复
│   ├── Ruff/Flake8 → 可自动修复
│   └── 操作:
│       npm run lint -- --fix
│       npx prettier --write .
│       ruff check . --fix
│
├── TypeScript/类型错误
│   ├── 缺少类型定义 → 添加类型
│   ├── 类型不兼容 → 修复类型签名
│   ├── 未使用的变量 → 删除或使用
│   └── 操作:
│       npm run typecheck 2>&1 | head -50
│       # 查看具体错误，逐个修复
│
├── 测试失败
│   ├── 断言失败 → 代码 bug 或测试需更新
│   ├── 超时 → 异步问题
│   ├── 环境问题 → CI 配置
│   └── 操作:
│       # 本地复现
│       npm test -- --testPathPattern="失败的测试"
│       pytest tests/test_xxx.py -v
│
├── 构建失败
│   ├── 导入错误 → 文件路径/模块不对
│   ├── 依赖缺失 → package.json 未更新
│   ├── 版本不兼容 → 检查 lockfile
│   └── 操作:
│       npm run build 2>&1 | tail -30
│       # 检查错误位置
│
├── 安全扫描失败
│   ├── 依赖漏洞 → 升级依赖
│   ├── 密钥泄露 → 移除并轮换
│   └── 操作:
│       npm audit
│       # 或查看扫描报告
│
└── 部署失败
    ├── 配置错误 → 检查部署配置
    ├── 权限问题 → 检查凭据
    └── 超时 → 检查健康检查
```

---

### 第3步: 判断是否是本次变更导致

```bash
# 检查 base branch 的 CI 状态
# 方法1: 查看 main 分支最近的 CI 运行
git log origin/main --oneline -5

# 方法2: 切到 base branch 运行同样的测试
git stash
git checkout main
npm test -- --testPathPattern="失败的测试"
# 如果在 main 上也失败 → 是已有问题
# 如果在 main 上通过 → 是本次变更导致
git checkout -
git stash pop
```

**决策**:
- 已有问题 → 告知用户（提供证据）
- 本次变更导致 → 修复

---

### 第4步: 修复

**Lint/Format 修复（最简单）**:
```bash
# 自动修复
npm run lint -- --fix
npx prettier --write $(git diff --name-only origin/main)
ruff check . --fix && ruff format .

# 提交
git add -A
git commit -m "style: 修复 lint/format 错误"
git push
```

**TypeScript 修复**:
```bash
# 逐个修复类型错误
npm run typecheck 2>&1 | grep "error TS"
# 根据错误修改对应文件

git add -A
git commit -m "fix: 修复类型错误"
git push
```

**测试修复**:
```bash
# 本地复现
npm test -- --testPathPattern="failing" --verbose

# 分析失败原因
# - 如果是代码 bug → 修复代码
# - 如果是测试过时 → 只在用户同意后修改测试
# - 如果是环境依赖 → 调整 CI 配置或跳过

git add -A
git commit -m "fix: 修复测试失败

- 根因: XXX
- 修复: YYY"
git push
```

**构建修复**:
```bash
# 本地构建验证
npm run build 2>&1

# 常见修复:
# - 缺少导入 → 添加 import
# - 模块路径错误 → 修正路径
# - 依赖缺失 → npm install xxx

git add -A
git commit -m "fix: 修复构建错误"
git push
```

---

### 第5步: 验证修复

```bash
# 本地运行完整检查
npm run lint && npm run typecheck && npm test && npm run build

# 推送后等待 CI
git push
git_pr_checks(repo, pull_number, wait_mode="all")
```

---

### 第6步: 重试限制

```
修复尝试次数:
├── 第 1 次: 正常修复
├── 第 2 次: 更仔细分析
├── 第 3 次: 最后尝试
└── 第 4 次: 停止，向用户求助
    ├── 说明已尝试的内容
    ├── 说明失败原因
    └── 请求指导
```

---

## CI 失败快速诊断表

| 错误关键词 | 可能原因 | 快速修复 |
|-----------|---------|---------|
| `Cannot find module` | 导入路径错误 | 检查文件路径和导出 |
| `Type 'X' is not assignable` | 类型不匹配 | 修复类型签名 |
| `Expected X but received Y` | 断言失败 | 修复代码逻辑 |
| `ENOENT` | 文件不存在 | 检查文件路径 |
| `Timeout` | 异步未完成 | 增加超时或修复 async |
| `Module not found` | 依赖缺失 | npm install 或添加依赖 |
| `SyntaxError` | 语法错误 | 检查对应行 |
| `Permission denied` | 权限问题 | 检查 CI 配置 |
| `Out of memory` | 内存不足 | 优化或增加资源 |
| `Rate limit` | API 限流 | 添加重试或缓存 |
