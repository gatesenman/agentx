# 自定义指南

> 如何修改和扩展规则，让 AI 助手适应你的项目和团队。

---

## 目录

1. [自定义的原则](#自定义的原则)
2. [修改核心规则](#修改核心规则)
3. [添加项目特定规则](#添加项目特定规则)
4. [团队协作配置](#团队协作配置)
5. [多语言/多框架项目](#多语言多框架项目)
6. [Monorepo 配置](#monorepo-配置)
7. [规则模板库](#规则模板库)

---

## 自定义的原则

### 什么应该自定义

| 类别 | 示例 | 建议 |
|------|------|------|
| 技术栈 | "用 pnpm 不用 npm" | 必须自定义 |
| 代码风格 | "函数最多 30 行" | 推荐自定义 |
| 测试要求 | "所有新函数必须有单测" | 推荐自定义 |
| 架构约束 | "不要在 Controller 里写业务逻辑" | 推荐自定义 |
| Git 规范 | "commit message 要关联 JIRA" | 按需自定义 |

### 什么不应该修改

- **安全规则** — "绝不暴露密钥" 这类不应该放宽
- **Git 保护** — "绝不 force push 到 main" 不应该取消
- **基本质量** — "代码必须可直接运行" 不应该降低

### 修改方法论

```
1. 确定你要改什么（添加/修改/删除规则）
2. 在对应 IDE 的规则文件中修改
3. 提交到 git（让团队共享）
4. 在实际使用中验证效果
5. 迭代优化
```

---

## 修改核心规则

### Claude Code (CLAUDE.md)

直接编辑 `CLAUDE.md`，添加你的项目特定规则:

```markdown
# CLAUDE.md

## [保留原有核心规则...]

---

## 项目特定规则

### 技术栈
- 前端: React 18 + TypeScript + Tailwind CSS
- 后端: FastAPI + Python 3.12
- 数据库: PostgreSQL + Prisma ORM
- 包管理: pnpm (绝不用 npm 或 yarn)
- 测试: Vitest (前端) + pytest (后端)

### 代码风格
- 组件文件用 PascalCase: `UserProfile.tsx`
- 工具函数用 camelCase: `formatDate.ts`
- API 路由用 kebab-case: `user-profile.ts`
- 每个文件只导出一个主要内容
- 函数最多 40 行，超过就拆分

### 架构约束
- 组件只能 import 同层或下层的模块
- API 调用必须经过 `src/lib/api/` 封装
- 全局状态用 Zustand store
- 不要用 useEffect 做数据获取，用 React Query

### 测试要求
- 所有新的 util 函数必须有单测
- API 端点必须有集成测试
- 测试文件和源文件同目录: `foo.ts` → `foo.test.ts`

### 部署
- 前端自动部署到 Vercel (main 分支)
- 后端手动部署: `make deploy-backend`
- PR 部署预览自动生成
```

### Cursor (.cursorrules)

在 `.cursorrules` 底部追加:

```markdown
## 项目特定规则

[你的规则内容，同上]
```

或者创建新的 `.cursor/rules/project-specific.mdc`:

```markdown
---
description: 本项目的特定技术栈和架构规则
alwaysApply: true
---

# 项目特定规则

[你的规则内容]
```

### 其他 IDE

方法类似——在对应格式的文件中追加你的项目规则。

---

## 添加项目特定规则

### 示例：React + TypeScript 项目

```markdown
## React 规则
- 优先使用函数组件 + Hooks
- Props 必须定义 TypeScript 接口
- 不用 `any` 类型，用 `unknown` 然后做类型守卫
- 事件处理函数命名: `handleXxx` (如 handleSubmit)
- 自定义 Hook 必须以 `use` 开头
- 避免 prop drilling 超过 3 层，用 Context 或状态管理

## 样式规则
- 用 Tailwind CSS，不写自定义 CSS
- 响应式设计用 Tailwind 断点: sm/md/lg/xl
- 颜色用 design token: `text-primary`, `bg-surface`
```

### 示例：Python 后端项目

```markdown
## Python 规则
- 类型注解: 所有函数参数和返回值都要有类型注解
- Docstring: 公共函数必须有 Google style docstring
- 错误处理: 不要裸 except，至少 `except Exception as e`
- 导入排序: isort 规则 (stdlib → third-party → local)
- 行长度: 最多 100 字符

## FastAPI 规则
- 路由函数用 async
- 请求/响应用 Pydantic model
- 错误返回用 HTTPException
- 依赖注入用 Depends()
```

### 示例：Go 项目

```markdown
## Go 规则
- 错误处理: 不要忽略 error，每个都要处理
- 命名: 接口用 -er 后缀 (Reader, Writer)
- 包名: 短小、全小写、不用下划线
- 测试: 用 table-driven tests
- 并发: 用 context.Context 传递取消信号
```

---

## 团队协作配置

### 分层策略

```
项目根/
├── CLAUDE.md (或 .cursorrules 等)     ← 团队规则（提交到 git）
├── CLAUDE.local.md                    ← 个人偏好（不提交）
└── .gitignore                         ← 忽略个人文件
```

### .gitignore 配置

```gitignore
# 个人 AI 规则文件（不提交）
CLAUDE.local.md
.cursorrules.local
```

### 团队规则 vs 个人偏好

| 内容 | 放哪里 | 示例 |
|------|--------|------|
| 技术栈 | 团队规则 | "用 pnpm" |
| 架构约束 | 团队规则 | "组件不超过 200 行" |
| 语言偏好 | 个人偏好 | "用中文回复" |
| 输出风格 | 个人偏好 | "解释详细一点" |
| Commit 前缀 | 团队规则 | "feat/fix/chore" |

---

## 多语言/多框架项目

### TypeScript + Python 混合项目

```markdown
## 全栈规则

### 前端 (src/frontend/)
- TypeScript strict mode
- React + Next.js
- pnpm install
- `pnpm lint` / `pnpm typecheck`

### 后端 (src/backend/)
- Python 3.12 + FastAPI
- uv sync
- `ruff check .` / `mypy .`

### 通用
- 改了前端要跑前端的 lint
- 改了后端要跑后端的 lint
- 改了两边都要跑
```

---

## Monorepo 配置

### 根目录 + 子包规则

```
monorepo/
├── CLAUDE.md                    ← 全局规则
├── packages/
│   ├── web/
│   │   └── CLAUDE.md            ← web 包特定规则
│   ├── api/
│   │   └── CLAUDE.md            ← api 包特定规则
│   └── shared/
│       └── CLAUDE.md            ← shared 包特定规则
```

**根目录 CLAUDE.md:**
```markdown
## Monorepo 规则
- 用 pnpm workspace
- 跨包引用用 `@scope/package-name`
- 改了 shared 包要跑所有依赖包的测试
- turborepo 管理构建: `pnpm turbo run build`
```

**子包 CLAUDE.md:**
```markdown
## Web 包规则
- Next.js 14 App Router
- 组件在 src/components/
- 页面在 src/app/
- API 调用在 src/lib/api/
```

---

## 规则模板库

### 模板: SaaS 产品

```markdown
## SaaS 项目规则

### 多租户
- 所有数据库查询必须带 tenant_id 过滤
- API 端点从 token 中提取 tenant，不从参数传
- 不允许跨租户数据访问

### 认证
- 用 JWT + Refresh Token
- 敏感操作需要二次验证
- 密码哈希用 bcrypt

### 计费
- feature flags 控制功能访问
- 用量计数要准确，不能丢
- 升降级要测试边界情况
```

### 模板: 开源库

```markdown
## 开源库规则

### API 设计
- 公共 API 必须向后兼容
- Breaking change 需要 major version bump
- 所有公共函数必须有 JSDoc/docstring

### 文档
- 新功能必须更新 README
- API 变更必须更新 CHANGELOG.md
- 示例代码必须可运行

### CI
- 支持 Node 18/20/22 三个版本
- 所有 PR 必须通过 lint + test + build
```

### 模板: 移动端 (React Native)

```markdown
## React Native 规则

### 平台差异
- 平台特定代码用 .ios.ts / .android.ts
- 用 Platform.select() 处理小差异
- 测试必须在两个平台都跑

### 性能
- 列表用 FlashList 而非 FlatList
- 图片必须指定尺寸
- 避免在 render 中创建新对象/函数

### 导航
- 用 React Navigation v6
- Screen 组件在 screens/ 目录
- 导航类型定义在 navigation/types.ts
```

---

## 下一步

- [工作流详解](./WORKFLOWS-GUIDE.md) — 4 个工作流的详细使用说明
- [迁移指南](./MIGRATION.md) — 从一个 IDE 切换到另一个
- [最佳实践](./BEST-PRACTICES.md) — 高效使用建议
