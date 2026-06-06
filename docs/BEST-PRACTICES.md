# 最佳实践

> 高效使用 AI 编程助手的建议和技巧。

---

## 目录

1. [规则编写最佳实践](#规则编写最佳实践)
2. [与 AI 协作的最佳实践](#与-ai-协作的最佳实践)
3. [项目配置最佳实践](#项目配置最佳实践)
4. [团队协作最佳实践](#团队协作最佳实践)
5. [安全最佳实践](#安全最佳实践)
6. [常见反模式](#常见反模式)

---

## 规则编写最佳实践

### 1. 具体优于模糊

```markdown
# 不好
- 写好的代码

# 好
- 函数最多 40 行
- 每个函数只做一件事
- 变量名用 camelCase，类名用 PascalCase
```

### 2. 用示例说明

```markdown
# 不好
- 用合适的错误处理

# 好
- 错误处理示例:
  ```typescript
  // 好
  try {
    const result = await fetchUser(id);
    return result;
  } catch (error) {
    if (error instanceof NotFoundError) {
      return null;
    }
    throw error;
  }
  
  // 不好
  try {
    return await fetchUser(id);
  } catch (e) {
    console.log(e);
  }
  ```
```

### 3. 说明"为什么"

```markdown
# 不好
- 不要用 moment.js

# 好
- 不要用 moment.js（已停止维护，包体积大）。用 date-fns 或 dayjs
```

### 4. 优先级明确

把最重要的规则放在前面。AI 对文件开头的内容遵循度更高。

```markdown
## 绝对不可以（最高优先级）
- 绝不暴露密钥
- 绝不 force push 到 main

## 必须做到
- 所有代码必须通过 lint
- 所有函数必须有类型注解

## 建议
- 优先使用已有组件
- 新组件尽量复用 design tokens
```

### 5. 精简为王

```markdown
# 不好（太啰嗦）
- 当你需要创建一个新的组件的时候，
  你应该首先查看一下项目中是否已经存在类似的组件，
  如果存在的话，你应该优先考虑复用或扩展它，
  而不是创建一个全新的组件...

# 好（简洁有力）
- 创建新组件前先搜索现有组件，能复用就不新建
```

---

## 与 AI 协作的最佳实践

### 1. 给足上下文

```markdown
# 不好
"修复 bug"

# 好
"用户报告: 点击'保存'按钮后表单数据丢失。
预期行为: 保存后显示成功提示，数据持久化。
实际行为: 页面刷新，数据回到修改前状态。
复现路径: 设置页 → 修改邮箱 → 点保存"
```

### 2. 一次一个任务

```markdown
# 不好
"修复登录 bug，顺便加个暗色模式，还有把那个页面重构一下"

# 好
"修复登录页面在输入错误密码时不显示错误提示的 bug"
# (完成后再给下一个任务)
```

### 3. 先探索再动手

```markdown
# 好的开始方式
"帮我看看 src/auth/ 目录的结构，理解一下登录流程"
# (理解了之后再)
"现在修复登录验证的 bug"
```

### 4. 反馈要具体

```markdown
# 不好
"不对，再试试"

# 好
"修复方向对了，但你改错文件了。
应该改 src/auth/login.ts 而不是 src/auth/register.ts。
另外请保留原来的错误处理逻辑。"
```

### 5. 利用规则作为反馈循环

如果 AI 重复犯同一个错误，把它加到规则里:

```markdown
## 项目规则
- 不要修改 src/generated/ 下的文件（这些是自动生成的）
- API 响应始终返回 { success: boolean, data: T, error?: string }
- 用 dayjs 而不是 moment（我们已经在迁移了）
```

---

## 项目配置最佳实践

### 1. 必备的辅助配置

除了 AI 规则文件，这些配置能让 AI 更好地工作:

```
项目/
├── .editorconfig          # 统一编辑器设置
├── .prettierrc            # 代码格式化
├── .eslintrc              # Lint 规则
├── tsconfig.json          # TypeScript 配置
├── .pre-commit-config.yaml  # Pre-commit hooks
└── .gitignore             # Git 忽略
```

### 2. README 要足够详细

AI 设置项目时会读 README，所以确保 README 包含:

```markdown
## 开发环境设置

### 前置条件
- Node.js 20+
- pnpm 8+
- Docker (用于本地数据库)

### 安装
```bash
pnpm install
docker compose up -d
pnpm db:migrate
pnpm dev
```

### 常用命令
- `pnpm dev` — 启动开发服务器
- `pnpm lint` — 运行 lint
- `pnpm typecheck` — 类型检查
- `pnpm test` — 运行测试
- `pnpm build` — 构建生产版本
```

### 3. 锁定工具版本

在规则中指定版本，避免 AI 用错版本:

```markdown
## 工具版本
- Node.js: 20.x (通过 .nvmrc 或 .node-version 指定)
- pnpm: 8.x
- Python: 3.12
- TypeScript: 5.4+
```

---

## 团队协作最佳实践

### 1. 规则版本控制

```bash
# 提交规则到 git
git add CLAUDE.md .cursorrules
git commit -m "chore: 更新 AI 编程规则"
```

### 2. 定期 Review 规则

每月 review 一次:
- 删除过时的规则
- 添加新发现的规则
- 精简冗余的规则

### 3. 新人入职

把 AI 规则作为新人入职文档的一部分:
- 规则文件本身就是项目规范的文档
- 新人可以让 AI 解释规则

### 4. Code Review 中利用规则

```markdown
## Review 标准
- AI 提交的 PR 也要人工 review
- Review 时对照规则检查:
  - [ ] 是否遵循了最小化修改原则
  - [ ] 是否有多余的注释
  - [ ] 是否通过了 lint/typecheck
  - [ ] commit message 是否规范
```

---

## 安全最佳实践

### 1. 规则中包含安全防线

```markdown
## 安全底线（不可删除）
- 绝不在代码中硬编码密钥、token、密码
- 绝不提交 .env、*.pem、credentials.json
- 绝不在日志中打印敏感信息
- 绝不禁用 HTTPS/TLS 验证
- 绝不在 URL 参数中传密码
```

### 2. 配合 Git Hooks

使用本仓库提供的 hooks:
```bash
./hooks/install-hooks.sh
# 安装 pre-commit/commit-msg/pre-push hooks
```

### 3. 配合 CI 检查

在 CI 中添加密钥扫描:
```yaml
# .github/workflows/security.yml
- name: Check secrets
  run: ./scripts/verify-no-secrets.sh
```

### 4. 个人文件隔离

```gitignore
# .gitignore
CLAUDE.local.md     # 可能包含个人配置信息
.env                # 环境变量
.env.local
*.pem
```

---

## 常见反模式

### ❌ 规则太长太详细

```markdown
# 反模式: 写了 50 页规则
# 结果: AI 读完前面忘了后面，效果反而差

# 正确做法: 核心规则控制在 5-10KB
# 详细的参考文档放 workflows/ 目录供需要时查看
```

### ❌ 规则互相矛盾

```markdown
# 反模式:
- "所有函数必须有注释"
- "不要写注释"

# 正确做法: 统一口径
- "公共 API 必须有 JSDoc，内部函数不需要注释"
```

### ❌ 只有禁止没有引导

```markdown
# 反模式:
- 不要用 var
- 不要用 class
- 不要用 any
- 不要...

# 正确做法: 告诉 AI 该怎么做
- 用 const/let 而非 var
- 用函数组件 + Hooks 而非 class 组件
- 用具体类型或 unknown + 类型守卫
```

### ❌ 期望 AI 了解隐含上下文

```markdown
# 反模式:
- "按照我们的规范来"
# AI 不知道"你们的规范"是什么

# 正确做法: 明确写出规范
- "函数用 camelCase，组件用 PascalCase，常量用 UPPER_SNAKE_CASE"
```

### ❌ 从不更新规则

```markdown
# 反模式: 半年前写的规则从没更新
# 项目早就从 webpack 迁到 vite 了但规则没改

# 正确做法: 规则是活文档
# 每次发现 AI 做错的事，就更新规则
```

---

## 效果衡量

### 如何知道规则有效？

1. **PR 被拒率下降** — AI 提交的 PR 一次过的概率增加
2. **代码风格统一** — AI 写的代码和人写的风格一致
3. **安全事件为零** — 没有密钥泄露、没有危险 git 操作
4. **协作更顺畅** — 不需要反复纠正 AI 的行为

### 推荐的迭代周期

```
第 1 周: 用默认规则
第 2 周: 根据实际使用，添加项目特定规则
第 1 月: Review 规则，删减无效的，补充缺失的
之后: 每月 review 一次，持续优化
```

---

## 下一步

- [使用教程](./USAGE-GUIDE.md) — 从零开始设置
- [自定义指南](./CUSTOMIZATION.md) — 深入定制
- [工作流详解](./WORKFLOWS-GUIDE.md) — 工作流使用说明
- [FAQ](./FAQ.md) — 具体问题解答
