# 功能实现工作流

## 触发条件
用户请求新功能、增强、或添加新的 API/组件/页面。

## 完整步骤

### 第1步: 理解需求
```
分析清单:
  □ 功能的核心目标是什么?
  □ 验收标准（什么算"做完"）?
  □ 有 UI 变更吗? 有设计稿吗?
  □ 需要新的 API 端点吗?
  □ 需要数据库变更吗?
  □ 有安全/权限要求吗?
  □ 需要向后兼容吗?

如有歧义: 提出澄清问题，但同时开始行动（研究代码库）
```

### 第2步: 探索代码库
```bash
# 找到相关的现有代码
grep -r "相关关键词" src/ --include="*.{ts,tsx,js,jsx}" -l
grep -r "相关关键词" src/ --include="*.py" -l

# 理解项目结构
find src/ -type f -name "*.ts" | head -30
ls -la src/components/   # 前端
ls -la src/api/          # 后端
ls -la src/models/       # 数据模型

# 检查现有类似功能的实现模式
cat src/components/已有组件.tsx   # 了解组件模式
cat src/api/已有端点.ts          # 了解 API 模式
cat src/models/已有模型.ts        # 了解数据模型模式

# 检查可复用的工具函数
find src/ -path "*/utils/*" -o -path "*/helpers/*" -o -path "*/lib/*" | head -20

# 检查依赖
cat package.json | grep -A 50 '"dependencies"'
# 或
cat pyproject.toml
```

### 第3步: 规划实现
```
创建 todo 列表:
  1. 需要创建的文件（列出路径和职责）
  2. 需要修改的文件（列出路径和改动点）
  3. 需要的新依赖（如有）
  4. 实现顺序（数据层 → 逻辑层 → 展示层）
  5. 边界情况清单

依赖检查:
  - 新库先确认 package.json 中是否已有
  - 不引入不必要的新依赖
  - 用项目已有的工具函数
```

### 第4步: 实现
```
编码原则:
  1. 遵循代码库中的现有模式
     - 组件结构（函数式/类式）
     - 状态管理方式
     - API 调用模式
     - 错误处理模式
     - 命名约定（camelCase/snake_case）

  2. Import 规范
     - 所有 import 放文件顶部
     - 按约定分组（第三方 → 内部 → 相对路径）
     - 不在函数内部 import

  3. 类型安全
     - 定义所有必要的类型/接口
     - 不用 any, unknown（除非真的需要）
     - 正确处理 null/undefined

  4. 安全
     - 永不暴露密钥
     - 输入验证
     - SQL 注入防护（参数化查询）
     - XSS 防护（转义用户输入）
```

### 第5步: Lint 和类型检查
```bash
# 运行 linter
npm run lint
# 或
ruff check .
# 或
cargo clippy

# 修复 lint 错误（自动修复优先）
npm run lint -- --fix
# 或
ruff check . --fix

# 运行类型检查
npm run typecheck
# 或
mypy src/
# 或
pyright
```

### 第6步: 测试
```bash
# 运行现有测试确保没破坏
npm test

# 如有测试基础设施，为新功能写测试
# 测试文件位置遵循项目约定:
# - src/__tests__/
# - src/模块名.test.ts
# - tests/

# 运行特定测试
npm test -- --grep "新功能"
```

### 第7步: 创建 PR
```bash
# 创建分支
git checkout -b devin/$(date +%s)-feat-功能名

# 暂存（特定文件，永不 git add .）
git add src/新文件1.ts src/新文件2.ts src/修改的文件.ts

# 提交
git commit -m "feat: 添加XX功能

- 新增了什么
- 修改了什么
- 影响范围"

# 推送
git push -u origin $(git branch --show-current)

# 创建 PR
# - 描述: 高信号、简洁、解释 WHY
# - 不重述 diff
# - 包含预览 URL（如有）
```

### 第8步: 等待 CI 并修复
```bash
# 等待 CI 检查
# 如果失败:
#   1. 查看失败日志
#   2. 修复问题
#   3. 提交并推送
#   4. 最多重复 3 次
#   5. 3 次后上报用户
```

### 第9步: 报告完成
```
发送给用户:
  - PR 链接
  - 预览部署 URL（如有）
  - 简要总结实现方案
  - 任何需要注意的事项
```

## 决策树
```
收到功能请求
├── 需求清晰? 
│   ├── 是 → 直接规划实现
│   └── 否 → 提问 + 同时研究代码库
│
├── 有类似功能已存在?
│   ├── 是 → 参考其模式实现
│   └── 否 → 参考最相近的代码模式
│
├── 需要新依赖?
│   ├── 是 → 项目中已有? → 直接用
│   │         └── 没有 → 确认真的需要 → npm install
│   └── 否 → 用现有工具函数
│
└── 变更范围大?
    ├── 是 → 拆分为多个小提交
    └── 否 → 单个提交
```
