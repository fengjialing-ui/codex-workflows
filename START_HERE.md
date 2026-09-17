# 文章生成工作流启动入口

当前版本见 workflow.json。读 AGENTS.md、EXECUTION.md、brief.md 和标准索引；仅加载本次文章类型与产品的标准。
新文章默认在生成流程内完成 publish_ready；只有明确要求修改已有文章才进入 optimization，独立回审按用户要求启用。
先运行 `python tools/preflight.py`，再用 tools/workflow_state.py 初始化任务并逐阶段执行。
发布前运行 `python tools/validate_article_package.py --package RUN_DIR`。旧 PowerShell 命令调用相同检查器。

## 实时 SERP 备用通道（SerpApi）

当运行环境没有 live Web Search，但允许访问 SerpApi 时，使用 `tools/serpapi_google_serp.py` 取得当前 Google 自然结果清单。将私钥仅保存在执行环境的 `SERPAPI_API_KEY`，不要写入仓库、任务文件、命令行或提交历史。例如：

```text
python tools/serpapi_google_serp.py --query "{主题}" --location "United States" --gl us --hl en --output-dir research/
```

该命令使用 `no_cache=true`，同时保存原始 JSON 和 `03_SERP与竞品分析.md` 骨架。它只解决 Top 10 结果采集；仍必须完成正文深读、页面类型复核、机会矩阵和官方事实核验。若 SerpApi 网络、配额或密钥失败，明确报告 `Network Restricted — SERP Fallback Blocked`，不要伪造 SERP。
最简调用：`按文章生成工作流执行：how_to｜主题｜市场｜语言，关键词见附件，推荐产品按项目配置，完整交付。`

仅给主题和关键词表时可用：`按文章生成工作流执行：主题为 [topic]；市场和语言沿用项目配置；关键词见附件；先按上游研究包接入标准生成 SERP 内容策略简报和文章 Outline，再把两份材料与关键词表交给原有内容生成流程。推荐产品为 [product]（可选）。`
