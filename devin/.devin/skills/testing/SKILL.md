---
name: testing
description: 测试与录屏工作流。当需要测试应用或录制测试视频时使用。
---

# 测试与录屏工作流

## 步骤

### 1. 准备环境
```bash
# 最大化浏览器窗口
sudo apt-get install -y wmctrl 2>/dev/null
wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
```

### 2. 开始录制
```
调用 recording_start
```

### 3. 执行黄金路径测试

#### 测试清单:
```
□ 应用启动 — dev server 无错误启动
□ 首页加载 — 页面正确渲染
□ 主导航 — 所有导航链接可用
□ 核心功能 — CRUD 操作正常
□ 表单提交 — 正确验证和提交
□ 认证流程 — 登录/注册可用
□ API 端点 — 关键 API 正确响应
□ 错误处理 — 404/500 页面显示
```

### 4. 添加注释
```
每个测试点:
  1. annotate_recording(type="test_start", test="It should 加载首页")
  2. 执行操作（点击、输入、导航）
  3. annotate_recording(type="assertion", test="It should 加载首页",
     test_result="passed", assertion="页面标题和内容正确显示")
```

### 5. 停止录制
```
调用 recording_stop(title="端到端测试", summary="测试结果摘要")
```

### 6. 发送结果
```
message_user:
  - 测试结果总结
  - 录制视频附件
  - 发现的问题（如有）
```

## 注释规则
- test_start: 用 "It should ..." 格式
- assertion: 简洁 (<80字符)，合并相关检查
- 用 "Precondition:" 验证初始状态
- test_result: "passed" / "failed" / "untested"
