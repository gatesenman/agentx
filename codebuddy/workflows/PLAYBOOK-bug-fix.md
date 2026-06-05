# Bug 修复工作流 (Playbook)

## 触发条件
- 用户报告 bug、错误、异常行为
- CI 中出现测试失败
- 生产环境报错
- 用户说"这个不工作"、"报错了"、"有个 bug"

---

## 完整步骤

### 第1步: 理解问题

**输入**: 用户的 bug 描述
**操作**:
1. 提取关键信息:
   - 预期行为 vs 实际行为
   - 复现步骤
   - 错误信息/调用栈
   - 影响范围（哪些用户/哪些环境）
2. 创建 TODO 清单
3. 如果信息不足，边搜索边问用户

**决策点**:
- 有明确错误信息 → 直接搜索错误位置
- 只有描述没有堆栈 → 需要先复现
- 用户说"之前还好的" → 检查最近 commits

```bash
# 搜索错误信息在代码中的位置
grep -r "错误关键词" --include="*.ts" --include="*.py"

# 检查最近的改动
git log --oneline -20
git log --oneline --since="3 days ago"
```

---

### 第2步: 定位根因

**策略 A — 有失败测试**:
```bash
# Node.js
npm test -- --grep "失败的测试名"
npx jest path/to/test.spec.ts --verbose

# Python
pytest tests/test_module.py::test_function -v
pytest tests/ -k "关键词" --tb=short

# Rust
cargo test test_name -- --nocapture
```

**策略 B — 运行时错误，需要复现**:
```bash
# 启动应用
npm run dev
# 或
python manage.py runserver
# 或
cargo run

# 通过 curl 触发错误路径
curl -X POST http://localhost:3000/api/endpoint -d '{"data":"test"}'
```

**策略 C — 回归 bug（之前好的）**:
```bash
# 检查是否 shallow clone
git rev-parse --is-shallow-repository
# 如果是: git fetch --unshallow

# 用 git bisect 找出引入 bug 的 commit
git bisect start
git bisect bad HEAD
git bisect good v1.2.0  # 或已知正常的 commit
# 运行测试判断好坏
git bisect run npm test -- --testPathPattern="相关测试"
```

**策略 D — 搜索代码理解逻辑**:
```bash
# 搜索相关函数/变量
grep -rn "functionName" src/
# 搜索类型定义
grep -rn "interface.*TypeName" --include="*.ts"
# 搜索用法
grep -rn "import.*from.*module" src/
```

---

### 第3步: 制定修复方案

**决策树**:
```
修复方案选择:
├── 一行修复（typo、条件反了、off-by-one）
│   → 直接修，不需要复杂分析
├── 逻辑修复（条件遗漏、边界情况）
│   → 分析所有调用方，确保不引入新问题
├── 类型修复（类型定义不对）
│   → 找到类型源头修改，检查所有使用处
├── 依赖修复（版本不兼容）
│   → 检查 changelog，测试升级后的兼容性
└── 架构修复（设计缺陷导致）
    → 评估影响范围，考虑是否需要重构
    → 如果范围大，先和用户确认方案
```

---

### 第4步: 实现修复

**原则**:
- 最小化修改。只改必要的部分
- 不顺便重构（除非重构就是修复方案）
- 保持现有代码风格
- 添加必要的 import

```bash
# 修改完后立即检查语法
npm run lint -- --fix  # 或
ruff check . --fix     # 或
cargo clippy --fix
```

---

### 第5步: 验证修复

```bash
# 1. 运行相关测试
npm test -- --testPathPattern="相关模块"
pytest tests/test_affected.py -v

# 2. 运行全量测试确保没有回归
npm test
pytest tests/

# 3. 运行 lint 和 typecheck
npm run lint && npm run typecheck
ruff check . && mypy .

# 4. 如果是运行时 bug，手动验证
npm run dev  # 启动后通过浏览器/curl 验证修复
```

---

### 第6步: 提交和创建 PR

```bash
# 精确添加修改的文件
git add src/path/to/fixed-file.ts

# Commit message 说明修了什么
git commit -m "fix: 修复 XXX 在 YYY 情况下的错误

- 根因: ZZZ
- 修复: AAA"

# 推送
git push origin fix/描述性分支名
```

**PR 描述模板**:
```markdown
## 问题
简述 bug 现象和影响

## 根因
简述为什么会出现这个 bug

## 修复
简述修复方案

## 验证
- [ ] 相关测试通过
- [ ] 全量测试无回归
- [ ] lint/typecheck 通过
```

---

### 第7步: CI 和后续

- 等待 CI 完成
- 如果 CI 失败:
  1. 查看失败日志
  2. 判断是否与本次修改相关
  3. 如果相关，修复并推新 commit
  4. 最多修 3 次，之后向用户求助
- CI 通过后通知用户

---

## 常见 Bug 模式速查

| 模式 | 典型表现 | 常见原因 |
|------|---------|---------|
| 空指针/undefined | `Cannot read property 'x' of undefined` | 数据可能为空但没判断 |
| 类型错误 | `TypeError: x is not a function` | 接口变更、依赖升级 |
| 竞态条件 | 偶发错误、时序相关 | async/await 遗漏、锁缺失 |
| 边界情况 | 特定输入失败 | 空数组、空字符串、负数、大数 |
| 回归 | "之前还好的" | 最近 commit 引入 |
| 环境相关 | "我这里好的" | env变量、版本差异、OS差异 |

---

## 异常处理

- **找不到 bug 根因**: 添加日志，让用户复现时提供更多信息
- **修复范围太大**: 与用户讨论是否拆分为多个 PR
- **涉及他人代码**: 在 PR 中 @mention 相关人员
- **需要数据验证**: 可以写一次性脚本验证数据状态
