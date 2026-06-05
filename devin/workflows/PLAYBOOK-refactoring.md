# 重构工作流 (Playbook)

## 触发条件
- 用户要求重构代码
- 用户说"优化..."、"重构..."、"清理..."
- 代码审查中发现需要重构

---

## 完整步骤

### 第1步: 理解重构目标

**关键问题**:
1. 重构的范围是什么？（单文件/模块/全局）
2. 重构的动机是什么？（性能/可读性/可维护性/去重）
3. 有什么约束？（不能破坏 API/不能改测试行为）

**决策点**:
```
重构规模:
├── 微重构 (单文件内)
│   → 直接执行，不需详细计划
├── 模块重构 (几个文件)
│   → 创建 TODO，逐步执行
└── 架构重构 (大范围)
    → 发送计划给用户确认
    → 可能需要多个 PR
```

---

### 第2步: 安全网建立

```bash
# 1. 确保测试通过（重构前的基线）
npm test
# 记录：当前通过 X 个测试

# 2. 如果没有相关测试
#    → 先写测试覆盖要重构的代码
#    → 测试通过后再开始重构

# 3. 确保 lint 和 typecheck 通过
npm run lint && npm run typecheck
```

**原则**: 没有测试覆盖就不重构（除非重构很简单且可以手动验证）

---

### 第3步: 分析现有代码

```bash
# 理解依赖关系
grep -rn "import.*from.*目标模块" src/
grep -rn "require.*目标模块" src/

# 理解调用方
grep -rn "目标函数\|目标类" src/ --include="*.ts"

# 理解类型
grep -rn "interface\|type.*目标" src/ --include="*.ts"
```

**输出**:
- 被重构代码的所有使用方
- 类型约束
- 潜在影响范围

---

### 第4步: 执行重构

**常见重构模式**:

#### A. 提取函数/方法
```typescript
// Before: 函数过长
function processData(data: Data[]) {
  // 50行验证逻辑
  // 30行转换逻辑
  // 20行保存逻辑
}

// After: 拆分为有意义的小函数
function processData(data: Data[]) {
  const validated = validateData(data);
  const transformed = transformData(validated);
  return saveData(transformed);
}
```

#### B. 消除重复
```bash
# 找到重复代码
# 提取到共享模块
# 替换所有使用处
```

#### C. 重命名（大范围）
```bash
# 用 MultiEdit 或 IDE 重命名
# 确保所有引用都更新
grep -rn "旧名称" src/  # 确认没有遗漏
```

#### D. 移动文件/模块
```bash
# 1. 移动文件
git mv src/old/path.ts src/new/path.ts

# 2. 更新所有导入
grep -rn "from.*old/path" src/ --include="*.ts" -l
# 逐个修改导入路径

# 3. 验证
npm run typecheck
```

#### E. 接口/类型重构
```typescript
// 1. 新建目标接口
// 2. 添加适配层（新旧兼容）
// 3. 逐步迁移使用方
// 4. 删除旧接口
```

---

### 第5步: 验证（每次小改动后）

```bash
# 每次修改一小步后都要验证
npm run typecheck  # 类型安全
npm test           # 行为不变
npm run lint       # 代码规范
```

**重要**: 重构应该是一系列小步骤，每步都保持代码可工作。不要做大爆炸式重构。

---

### 第6步: 提交策略

```bash
# 选项A: 单个提交（小重构）
git add -A
git commit -m "refactor: 重构 XXX 模块提升可读性"

# 选项B: 多个原子提交（大重构）
git add src/utils/extracted.ts
git commit -m "refactor: 提取通用验证逻辑到 utils"

git add src/modules/feature.ts
git commit -m "refactor: 简化 feature 模块，使用提取的 utils"

git add src/routes/api.ts
git commit -m "refactor: 统一 API 路由错误处理"
```

---

### 第7步: PR 描述

```markdown
## 重构概述
简述重构了什么、为什么重构。

## 变更范围
- `src/utils/` — 提取的通用逻辑
- `src/modules/` — 简化后的模块

## 不变的行为
- API 接口无变化
- 测试全部通过
- 性能无退化

## 验证
- [ ] 所有测试通过
- [ ] lint/typecheck 通过
- [ ] 功能行为不变
```

---

## 重构原则清单

| 原则 | 说明 |
|------|------|
| 保持行为不变 | 重构不改变外部可观察的行为 |
| 小步前进 | 每次一个小改动，保持可编译 |
| 有测试覆盖 | 没测试不重构 |
| 不混合重构和功能 | 一个 PR 只做重构或只做功能 |
| 先简单后复杂 | 从最简单的重构开始 |
| 保持现有约定 | 重构不是引入新风格的机会 |

---

## 不应该做的重构

- 没有明确理由的重构（"看着不顺眼"不够）
- 用户没要求的大范围重构
- 破坏 API 兼容性的重构（除非用户同意）
- 在修 bug 的同时做重构（分开做）
