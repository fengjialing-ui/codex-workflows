# 工作流维护状态

执行版本：workflow.json（3.1.0）。本次已统一入口、路由、阶段记录与跨平台发布检查。
各主题任务在独立运行目录保存 workflow-state.json；本文件只记录工作流维护，不替代单任务进度。
验证命令：`python -m unittest discover -s tests -v`。
新任务从 START_HERE.md 开始；长期市场、语言和产品要求在 brief.md 中配置一次，本次任务变化写入各自的 task-brief.md。
