# Devin MCP 工具与配置

## 内建工具（始终可用）

### 文件操作
| 工具 | 描述 |
|------|------|
| `read` | 读取文件内容（绝对路径，支持 offset/limit） |
| `write` | 写入文件（覆盖） |
| `edit` | 文件中精确字符串替换 |
| `MultiEdit` | 单文件中原子化多次替换 |
| `find_file_by_name` | Glob 模式文件搜索 |
| `grep` | 文件中正则搜索（基于 ripgrep） |
| `notebook_read` | 读取 Jupyter notebook |
| `notebook_edit` | 编辑 Jupyter notebook 单元格 |

### Shell 与进程
| 工具 | 描述 |
|------|------|
| `exec` | 在持久化会话中执行 shell 命令 |
| `get_output` | 读取后台进程输出 |
| `write_to_process` | 向交互式进程写入输入 |
| `kill_shell` | 终止后台 shell 进程 |

### Git 与 PR 操作
| 工具 | 描述 |
|------|------|
| `git_create_pr` | 创建 Pull Request |
| `git_view_pr` | 查看 PR 详情、评论、CI 状态 |
| `git_update_pr` | 更新 PR 标题/描述 |
| `git_comment_on_pr` | 在 PR 上发布评论 |
| `git_edit_comment` | 编辑已有 PR 评论 |
| `git_delete_comment` | 删除 PR 评论 |
| `git_pr_checks` | 检查 CI 状态（带等待模式） |
| `git_ci_job_logs` | 获取 CI 任务日志 |
| `git_take_over_pr` | 接管已有 PR 持续工作 |
| `git_close_pr` | 关闭 PR（不合并） |
| `git_add_labels` | 添加 PR 标签 |
| `git_remove_labels` | 移除 PR 标签 |
| `git_update_pr_base` | 更改 PR base 分支 |
| `git_list_repos` | 列出可访问的仓库 |
| `fetch_pr_template` | 获取仓库的 PR 模板 |

### 浏览器与 Computer
| 工具 | 描述 |
|------|------|
| `computer` | 鼠标/键盘与 GUI 桌面交互 |
| `browser_console` | 在浏览器控制台运行 JavaScript |
| `web_search` | 网页搜索 |
| `web_get_contents` | 获取完整网页内容 |

### 通信
| 工具 | 描述 |
|------|------|
| `message_user` | 向用户发送消息（唯一通信方式） |
| `request_secret` | 向用户请求凭据 |
| `suggest_save_secret` | 建议永久保存会话密钥 |

### 部署
| 工具 | 描述 |
|------|------|
| `deploy` | 部署前端/后端，暴露端口，查看日志 |

### 录屏
| 工具 | 描述 |
|------|------|
| `recording_start` | 开始录屏 |
| `recording_stop` | 停止录制并获取视频 |
| `annotate_recording` | 向录制添加结构化注释 |

### 环境与知识
| 工具 | 描述 |
|------|------|
| `read_environment_config` | 读取环境蓝图 |
| `update_environment_config` | 建议蓝图变更 |
| `suggest_knowledge` | 建议知识条目 |
| `suggest_skill_pr` | 建议技能文件 PR |
| `list_knowledge_notes` | 列出可用知识 |
| `get_knowledge_note` | 下载完整知识笔记 |
| `save_browser_profile` | 持久化浏览器状态 |

### 任务管理与工具
| 工具 | 描述 |
|------|------|
| `todo_write` | 创建/更新任务列表 |
| `wait` | 基于时间的等待（最多 600 秒，新输入时取消） |
| `stop` | 静默结束会话（不向用户发消息） |
| `report_blocker` | 报告运维问题 (user/org_admin/cognition) |
| `upload_attachment` | 上传文件到云存储，获取 URL |
| `skill` | 调用/发现/搜索技能（模式: invoke, list, search） |
| `list_secrets` | 列出已配置密钥（名称/类型，不含值） |
| `enter_test_mode` | 进入测试模式验证 PR |
| `read_build_logs` | 列出/获取 snapshot 构建日志 |
| `devin_docs` | 搜索 Devin 文档（MCP 工具） |

---

## Devin MCP 服务器（远程 API）

### 会话管理
| 动作 | 描述 |
|------|------|
| `devin_session_create` | 创建子 Devin 会话 |
| `devin_session_interact` | 获取/消息/终止会话 |
| `devin_session_search` | 搜索和过滤会话 |
| `devin_session_gather` | 等待多个会话完成 |
| `devin_session_events` | 检查会话事件 |

### 知识管理
| 动作 | 描述 |
|------|------|
| `devin_knowledge_manage` | 知识笔记的增删改查 |
| 操作: list, get, create, update, delete, folders |

### Playbook 管理
| 动作 | 描述 |
|------|------|
| `devin_playbook_manage` | Playbook 的增删改查 |
| 操作: list, get, create, update, delete |

### 定时任务管理
| 动作 | 描述 |
|------|------|
| `devin_schedule_manage` | 管理定时会话 |
| 操作: list, get, create, update, delete |

### Wiki 与文档
| 动作 | 描述 |
|------|------|
| `read_wiki_structure` | 获取仓库文档主题 |
| `read_wiki_contents` | 查看仓库文档 |
| `ask_question` | AI 驱动的仓库问答 |
| `generate_wiki` | 生成代码库 wiki |
| `list_available_repos` | 列出可查询的仓库 |

### 自动化管理
| 动作 | 描述 |
|------|------|
| `devin_automation_manage` | 创建/管理事件驱动自动化 |
| 操作: schemas, create, list, get, update, delete |

### 集成管理
| 动作 | 描述 |
|------|------|
| `list_integrations` | 列出已安装和可用的集成 |
| `list_mcp_servers` | 列出可用的 MCP 服务器 |
