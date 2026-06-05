# 功能实现工作流 (Playbook)

## 触发条件
- 用户要求添加新功能
- 用户说"实现..."、"添加..."、"创建..."
- Issue 类型为 feature request

---

## 完整步骤

### 第1步: 需求分析

**操作**:
1. 提取功能需求的核心要点
2. 识别约束条件（技术栈、性能、兼容性）
3. 确认验收标准（功能做到什么程度算完成）
4. 如果需求不明确，在开始调研的同时向用户确认

**决策点**:
```
需求清晰度:
├── 完全清晰 → 直接规划实现
├── 大方向清晰，细节不明 → 边做边确认
└── 需求模糊 → 先研究代码库再提方案
```

---

### 第2步: 代码库调研

```bash
# 找到相关模块
grep -rn "相关功能关键词" src/ --include="*.ts"
find . -name "*相关名称*" -type f

# 理解现有架构
cat src/modules/index.ts  # 入口
cat src/routes/index.ts   # 路由

# 查看类似功能的实现（作为参考）
grep -rn "类似功能" src/ --include="*.ts" -l
```

**关键输出**:
- 现有类似功能的实现模式
- 应该在哪些文件/目录添加代码
- 需要修改哪些已有文件
- 依赖关系图

---

### 第3步: 制定实现计划

**计划内容**:
```markdown
## 实现计划

### 新建文件
- src/modules/feature/index.ts — 模块入口
- src/modules/feature/types.ts — 类型定义
- src/modules/feature/service.ts — 业务逻辑

### 修改文件
- src/routes/index.ts — 添加新路由
- src/modules/index.ts — 注册新模块

### 步骤
1. 定义类型接口
2. 实现核心逻辑
3. 添加路由/端点
4. 集成到现有系统
5. lint + typecheck
```

**决策点**:
```
实现复杂度:
├── 小功能 (1-3 文件) → 直接实现
├── 中等功能 (4-8 文件) → 创建 TODO，逐步实现
└── 大功能 (8+ 文件) → 发送计划给用户确认后再实现
```

---

### 第4步: 实现核心逻辑

**原则**:
- 先写类型定义（接口先行）
- 再写核心逻辑
- 最后写胶水代码（路由、注册等）
- 遵循现有项目的模式和约定
- 不引入新依赖，除非必要（必要时先确认 package.json 中有）

**常见实现模式**:

```typescript
// 1. 类型定义 (types.ts)
export interface FeatureInput {
  name: string;
  options?: FeatureOptions;
}

export interface FeatureOutput {
  id: string;
  result: Result;
}

// 2. 核心逻辑 (service.ts)
import { FeatureInput, FeatureOutput } from './types';

export class FeatureService {
  async execute(input: FeatureInput): Promise<FeatureOutput> {
    // 实现...
  }
}

// 3. 路由/端点 (route.ts)
import { FeatureService } from './service';

router.post('/feature', async (req, res) => {
  const service = new FeatureService();
  const result = await service.execute(req.body);
  res.json(result);
});
```

---

### 第5步: 集成和连接

```bash
# 确保新代码被正确导入
grep -n "import.*feature" src/

# 确保路由被注册
cat src/routes/index.ts

# 确保类型导出正确
cat src/modules/feature/index.ts
```

---

### 第6步: 验证

```bash
# 1. 编译通过
npm run build  # 或 tsc --noEmit

# 2. lint 通过
npm run lint

# 3. typecheck 通过
npm run typecheck

# 4. 现有测试没有回归
npm test

# 5. 功能验证（如果是 API）
npm run dev &
curl -X POST http://localhost:3000/api/feature -d '{"name":"test"}'
```

---

### 第7步: 创建 PR

```bash
git checkout -b feat/feature-name
git add src/modules/feature/ src/routes/index.ts
git commit -m "feat: 添加 XXX 功能

- 实现了 YYY 的核心逻辑
- 添加了 ZZZ 端点
- 集成到现有模块系统"

git push origin feat/feature-name
```

**PR 描述**:
```markdown
## 概述
添加了 XXX 功能，允许用户 YYY。

## 实现
- `src/modules/feature/` — 核心逻辑
- `src/routes/` — 新增 API 端点

## 使用方式
```bash
POST /api/feature
Body: {"name": "example"}
Response: {"id": "...", "result": {...}}
```

## 验证
- [ ] 编译通过
- [ ] lint/typecheck 通过
- [ ] 现有测试无回归
```

---

## 常见功能类型速查

| 功能类型 | 典型文件 | 注意事项 |
|---------|---------|---------|
| API 端点 | route + service + types | 错误处理、输入验证 |
| UI 组件 | component + styles + tests | 响应式、无障碍 |
| 数据模型 | model + migration + seed | 迁移要用生成器 |
| 后台任务 | worker + queue + config | 重试机制、幂等性 |
| 中间件 | middleware + config | 顺序、错误传递 |
| CLI 命令 | command + help + tests | 参数解析、帮助文档 |
