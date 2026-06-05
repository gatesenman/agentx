# Bug 修复工作流

## 触发条件
用户报告 bug、错误、异常行为，或 CI 中出现测试失败。

## 完整步骤

### 第1步: 理解问题
```
输入: 用户的 bug 描述
操作:
  1. 提取关键信息:
     - 预期行为是什么?
     - 实际行为是什么?
     - 复现步骤是什么?
     - 错误信息/调用栈?
  2. 创建 todo 列表跟踪进度
输出: 清晰的问题定义
```

### 第2步: 复现问题
```bash
# 如有失败测试，直接运行
npm test -- --grep "失败的测试名"
# 或
pytest tests/test_module.py::test_function -v

# 如是运行时错误，启动应用复现
npm run dev
# 然后通过浏览器或 curl 触发错误路径

# 如是构建错误
npm run build 2>&1 | tee /tmp/build-error.log
```
确认: 在当前分支上能复现该问题。

### 第3步: 定位源头
```bash
# 搜索相关函数名/变量名/错误消息
grep -r "函数名" src/ --include="*.ts" -n
grep -r "错误消息关键词" src/ -n

# 查看谁最后修改了相关代码
git log --oneline -20 -- src/相关文件.ts
git blame src/相关文件.ts | grep "关键行"

# 查看最近提交是否引入了问题
git log --oneline -10
git diff HEAD~5..HEAD -- src/相关目录/
```

### 第4步: 根因分析
```
检查清单:
  □ 追踪执行路径（从入口到错误点）
  □ 检查类型是否正确（参数类型、返回类型）
  □ 检查 null/undefined 处理
  □ 检查边界条件（空数组、零值、超长字符串）
  □ 检查异步操作（竞态条件、未 await 的 Promise）
  □ 检查数据流（状态管理、props 传递）
  □ 检查外部依赖（API 响应格式变化、版本兼容性）

关键: 理解"为什么"失败，不只是"在哪里"失败
```

### 第5步: 实现修复
```
原则:
  - 最小化变更 — 只改必要的代码
  - 遵循现有代码模式
  - 添加必要的 import（放文件顶部）
  - 写通用方案，不是特殊情况 hack
  - 不用 try/catch 掩盖错误
  - 不用 Any, getattr, setattr
  - 除非被要求，不修改测试

工具:
  - 编辑前先读取文件
  - 用编辑工具而非 shell 命令（cat, echo, awk）
  - 确保 old_string 在文件中唯一
```

### 第6步: 验证修复
```bash
# 1. 运行原始失败的测试
npm test -- --grep "原来失败的测试"

# 2. 运行相关测试套件
npm test -- src/相关模块/

# 3. 运行完整测试
npm test

# 4. Lint 检查
npm run lint

# 5. 类型检查
npm run typecheck

# 6. 如有必要，手动验证
npm run dev
# 通过浏览器确认修复
```

### 第7步: 创建 PR
```bash
# 创建分支
git checkout -b devin/$(date +%s)-fix-bug描述

# 暂存特定文件（永不 git add .）
git add src/修改的文件1.ts src/修改的文件2.ts

# 提交
git commit -m "fix: 修复了XX问题的根因

根因: 描述根本原因
修复: 描述修复方案"

# 推送
git push -u origin $(git branch --show-current)

# 创建 PR（通过工具或 CLI）
# PR 描述中解释根因
# 如适用，引用 bug 报告/issue 编号
```

## 决策树
```
收到 bug 报告
├── 有失败测试? → 直接运行测试复现
├── 有错误消息? → grep 搜索错误消息定位源头
├── 只有行为描述? → 启动应用手动复现
│
复现成功?
├── 是 → 继续定位
├── 否 → 检查环境差异，询问用户更多信息
│
修复后测试通过?
├── 是 → 运行完整测试 + lint → 创建 PR
├── 否 → 重新分析根因，可能修复不完整
```
