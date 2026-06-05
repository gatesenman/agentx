# 代码重构工作流

## 触发条件
用户请求代码清理、结构调整、性能优化或现代化，但不改变外部行为。

## 完整步骤

### 第1步: 理解范围
```
确认清单:
  □ 哪些代码/模块需要重构?
  □ 动机: 可读性? 性能? 可维护性? 技术债?
  □ 约束: 向后兼容? API 稳定性? 性能要求?
  □ 范围: 单个函数? 单个文件? 整个模块?
  □ 有测试覆盖吗?（重构的安全网）
```

### 第2步: 分析现有代码
```bash
# 阅读目标代码
cat src/目标文件.ts

# 找到所有引用该代码的地方
grep -r "函数名\|类名\|模块名" src/ --include="*.ts" -n

# 检查测试覆盖
find tests/ -name "*目标*" -o -name "*相关*"
grep -r "函数名" tests/ -l

# 检查 export/import 依赖链
grep -r "from.*目标模块" src/ -n
grep -r "import.*目标模块" src/ -n

# 查看最近修改历史
git log --oneline -10 -- src/目标文件.ts
```

### 第3步: 规划重构
```
拆分为安全步骤:
  1. 每步只做一个逻辑变更
  2. 每步都可独立验证（测试通过）
  3. 每步都可独立回滚

常见重构模式:
  - 提取函数/方法
  - 重命名变量/函数（全局搜索替换）
  - 移动文件/模块（更新所有 import）
  - 简化条件逻辑
  - 消除重复代码（DRY）
  - 拆分大文件
  - 合并碎片文件
  - 更新旧 API 调用
  - 改进类型定义

创建 todo 列表跟踪每个步骤
```

### 第4步: 增量实现
```bash
# 每个重构步骤:

# 1. 做变更
# （使用编辑工具修改代码）

# 2. 运行测试验证行为不变
npm test

# 3. 运行 lint/typecheck
npm run lint
npm run typecheck

# 4. 通过后提交
git add src/改的文件.ts
git commit -m "refactor: 描述这一步做了什么

不改变外部行为"

# 重复直到所有步骤完成
```

### 第5步: 最终验证
```bash
# 运行完整测试套件
npm test

# Lint + 类型检查
npm run lint
npm run typecheck

# 如适用，启动应用验证
npm run dev
# 手动检查关键功能是否正常

# 构建检查
npm run build
```

### 第6步: 创建 PR
```bash
git checkout -b devin/$(date +%s)-refactor-描述
git push -u origin $(git branch --show-current)

# PR 描述:
# - 清晰描述重构了什么和为什么
# - 明确说明: 没有行为变更
# - 列出每个重构步骤方便审查
# - 如有性能改善，附带数据
```

## 重构原则
```
必须遵守:
  ✓ 重构时永不改变外部行为
  ✓ 每个提交做一个逻辑变更
  ✓ 每个提交后测试通过
  ✓ 保持提交小而聚焦

禁止:
  ✗ 重构和功能变更混在一个提交
  ✗ 跳过测试验证
  ✗ 一次性大规模改动（拆小步骤）

发现 bug 时:
  → 在单独提交中修复，注明是 bug fix 不是重构
```

## 重命名参考脚本
```bash
# 安全重命名函数/变量（全项目）
# 1. 先搜索所有用法
grep -rn "旧名称" src/ tests/ --include="*.{ts,tsx,js,jsx}"

# 2. 逐文件替换（用编辑工具，不用 sed）
# 确保每个替换都正确（不误替换部分匹配）

# 3. 运行测试确认
npm test

# 4. 运行 typecheck 确认没遗漏
npm run typecheck
```
