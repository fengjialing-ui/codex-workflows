# Codex Workflows

当前执行版本：**3.1.0**。版本以 `workflow.json` 为准；入口见 `START_HERE.md`。本次升级记录见 `RELEASE_NOTES.md`。

这是一个用于跨电脑继续 Codex 工作的私有工作区。当前支持 How-to、Top 评测、VS、泛主题、Alternatives 与 What Is & Specs 的新建文章生成；所有任务先受 `standards/00-交付契约与发布级验收_v1.md` 管理。

## 使用方法

1. 在 `brief.md` 写清楚长期默认值；使用 `任务启动指令模板.md` 提供本次任务的字段。
2. 明确选择 `complete_draft` 或 `publish_ready`。用户说“完整交付/终稿/可发布”时必须选择 `publish_ready`。
3. 让 Codex 读取 `AGENTS.md`、`brief.md`、`STATUS.md` 和交付契约后先输出任务启动卡；缺项必须先确认，不能自行推测。
4. 系统按 `standards/08-多类型文章调度与共享标准_v1.md` 路由到对应模块。
5. 新文章 `publish_ready` 必须执行 `standards/13-新文章生成终稿闭环_v1.md` 与 `standards/11-可执行发布闸门与文件一致性_v1.md`：在文章生成流程内直接完成真实视觉、最终 Word、等价性和渲染。`10-发布级Article-Review工作流_v1.md` 只用于用户明确要求的独立回审或旧文优化。运行 `python tools/validate_article_package.py --package RUN_DIR`；只有检查器输出 `PASS — Publish Ready`、且渲染记录哈希匹配 `06_完整文章.docx` 后，才可生成 ZIP、输出到 `outputs/` 并标为 Final。
6. 更新 `STATUS.md`，然后提交并同步到 GitHub。

## 旧文回审的默认行为

用户说“优化、回审、SEO 优化或提升质量”时，默认保留并增量优化原文章，不重写。执行前必须建立 `13_内容资产保留审计.md`；没有用户明确确认，不能将原文压缩超过 30%、删除有效表格/案例/流程，或替换原图。

最终交付的主文件始终是可发布的 `06_完整文章.docx`：完整正文、SEO 元信息、嵌入的真实场景化图片、图注、Alt、表格、链接和用户要求的关键词展示。审核说明、图片规划、关键词表和单张图片只能作为支持材料，不能替代终稿。

## 换电脑后

下载本仓库，打开该文件夹，向 Codex 说明：

> 请阅读 `AGENTS.md`、`brief.md`、`STATUS.md` 和 `standards/00-交付契约与发布级验收_v1.md`，先报告当前交付等级、已通过闸门、阻断项和下一步，再继续这个项目。

`work/` 用于临时文件，不会上传到 GitHub。

## 示例状态

`examples/how-to-remove-sunlight-glare-from-photo/` 是顶层唯一的当前完整内容包参考，提供实际视觉、最终 Word、标题语义和 QA 记录；真实状态为 `Content Complete — Render QA Blocked`。旧的 `how-to-remove-noise-from-anime-videos/` 已移入 `examples/legacy/`，仅保留作历史结构参考，不能作为发布级通过样例。当前示例只有在具备 DOCX 渲染能力的环境中通过统一发布检查器后，才可升级为 `Publish Ready` 参考终稿。

## 发布级的两个关键停点

1. 用户指定产品与研究结论不匹配时，Codex 必须先报告冲突并等你确认产品策略；不能自行排除产品后继续交付。
2. Word 版与 Markdown 不等价、图片无 Alt、来源不可点击、Word 未渲染，或检查器未通过时，任务不能是 `Publish Ready`。如果正文、图片与 Word 已完成但本机渲染器不可用，状态必须是 `Content Complete — Render QA Blocked`；不得用 ZIP、复核版 DOCX 或“内容已完成”措辞绕过发布资格。
