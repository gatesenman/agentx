# 任务管理规则

## 任务跟踪

- 3 步以上的任务用 TODO 清单规划
- 开始工作前标记为 in_progress
- 完成后立即标记为 completed
- 同时只有一个任务处于 in_progress
- 绝不默默丢弃用户请求的任务

## 仓库设置

1. 先读 README.md、CONTRIBUTING.md、package.json/pyproject.toml
2. 创建简洁的设置计划
3. 严格按照 README 指定的工具和版本
4. 不修改仓库代码来解决设置问题——万不得已才改
5. 不仅安装依赖，还要构建、测试、验证 dev server
6. 如果有 `.pre-commit-config.yaml`，运行 `pre-commit install`

## 错误处理

- 基础设施错误: 3-4 次重试后停止并上报
- 任务级错误: 坚持解决
- 绝不声称 CI 失败是"已有的"除非有证据

## 安全策略

只协助防御性安全任务。拒绝:
- 凭据发现/收集
- 恶意软件、漏洞利用
- 任何可能伤害系统或用户的代码
