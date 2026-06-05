---
name: debugging
description: 调试工作流。当需要定位和修复 bug 时使用。
---

# 调试工作流

## 步骤

### 1. 复现问题
```bash
# 运行失败的测试
npm test -- --grep "失败的测试名" --verbose
# 或
pytest tests/test_file.py::test_name -v

# 运行时错误 → 启动应用
npm run dev
# 通过浏览器/curl 触发错误

# 记录精确的错误消息和调用栈
```

### 2. 定位源头
```bash
# 搜索相关代码
grep -r "函数名" src/ --include="*.ts" -n
grep -r "错误消息" src/ -n

# 查看修改历史
git log --oneline -20 -- src/相关文件.ts
git blame src/相关文件.ts | grep "关键行"

# 最近变更
git diff HEAD~5..HEAD -- src/相关目录/
```

### 3. 理解上下文
```
检查:
  □ 函数签名和参数类型
  □ 返回类型
  □ 调用链（谁调用了这个函数）
  □ 数据流（状态从哪来）
  □ import 依赖
```

### 4. 根因分析
```
检查清单:
  □ 类型是否正确
  □ null/undefined 处理
  □ 边界条件（空数组、零值）
  □ 异步操作（竞态、未 await）
  □ 数据流（状态管理、props）
  □ 外部依赖（API 格式变化）
```

### 5. 实现修复
```
原则:
  - 最小化变更
  - 遵循现有模式
  - 添加必要 import
  - 写通用方案
  - 不用 try/catch 掩盖
  - 不用 Any/getattr
  - 不改测试
```

### 6. 验证
```bash
# 原始失败测试
npm test -- --grep "原来失败的"

# 相关测试
npm test -- src/相关模块/

# 完整测试
npm test

# Lint + 类型
npm run lint
npm run typecheck
```

### 7. 创建 PR
```bash
git checkout -b devin/$(date +%s)-fix-描述
git add src/修改的文件.ts
git commit -m "fix: 修复XX问题

根因: ...
修复: ..."
git push -u origin $(git branch --show-current)
```
