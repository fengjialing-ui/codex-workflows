# 文章生成工作流启动入口

当前版本见 workflow.json。读 AGENTS.md、EXECUTION.md、brief.md 和标准索引；仅加载本次文章类型与产品的标准。
新文章默认在生成流程内完成 publish_ready；只有明确要求修改已有文章才进入 optimization，独立回审按用户要求启用。
先运行 `python tools/preflight.py`，再用 tools/workflow_state.py 初始化任务并逐阶段执行。
发布前运行 `python tools/validate_article_package.py --package RUN_DIR`。旧 PowerShell 命令调用相同检查器。
最简调用：`按文章生成工作流执行：how_to｜主题｜市场｜语言，关键词见附件，推荐产品按项目配置，完整交付。`

仅给主题和关键词表时可用：`按文章生成工作流执行：主题为 [topic]；市场和语言沿用项目配置；关键词见附件；先按上游研究包接入标准生成 SERP 内容策略简报和文章 Outline，再把两份材料与关键词表交给原有内容生成流程。推荐产品为 [product]（可选）。`
