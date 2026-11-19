# AgentX — 多 IDE AI 智能体运行基础设施

**中文** · [English](README.md) · 版本 1.1.0

按 IDE 分类的规则、工作流、技能、记忆和工具配置，复制进项目即可使用。

## 端到端用法（1.1.0）

不必把 CLI 装进系统目录。在仓库里可以直接跑：

```bash
mkdir -p /tmp/my-project
./cli/agentx init --ide cursor --target /tmp/my-project
./cli/agentx doctor cursor --target /tmp/my-project
```

`init` 是推荐入口，内部调用 `install`。目标目录里还没有 IDE 文件时，`doctor` 会以非 0 退出。仓库地址是 [gatesenman/agentx](https://github.com/gatesenman/agentx)。

```bash
# 仓库内检查
./cli/tests/smoke.sh
```
