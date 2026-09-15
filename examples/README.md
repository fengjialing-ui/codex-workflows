# 示例与回归参考

## 当前参考

`how-to-remove-sunlight-glare-from-photo/` 是顶层唯一的当前完整内容包参考：它包含 `00`–`14`、实际视觉资产、最终 Word、无障碍报告、来源、事实核验和已修正的 Word 标题语义映射。该包的真实状态是 `Content Complete — Render QA Blocked`，因为生成环境没有 LibreOffice/soffice；它可用于参考完整文件结构、内容边界和 P0 检查记录，**不得**作为 `PASS — Publish Ready` 的替代证据。

## 历史参考

`legacy/how-to-remove-noise-from-anime-videos/` 是旧 How-to 内容结构参考。它可用于理解研究、Content Brief、关键词映射、正文与 QA 文件之间的关系，但**不是**当前 `publish_ready` 的通过样例：它早于真实视觉资产、资产保留审计、最终交付清单、DOCX 渲染哈希和可执行发布闸门。

不得复制该示例中的 `Pass`、版本记录或 QA 结论来证明新任务通过；每个任务必须使用自己的研究、文章、Word、视觉和渲染证据运行当前检查器。

## 必须补充的发布级参考样例

在具备 LibreOffice/soffice 或等效可复现渲染能力的环境中，为 `how-to-remove-sunlight-glare-from-photo/` 补齐逐页渲染证据，或新增一个单主题、单市场、单语言的完整 How-to 参考包。它必须：

1. 通过 `tools/Test-ArticleGenerationPreflight.ps1`；
2. 包含 `00`–`14` 规定的交付材料、`assets/` 和 `qa-render.json`；
3. 使用同一份 `06_完整文章.docx` 完成 Markdown/Word 标题、表格、链接、Alt 与内容等价性检查；
4. 包含可复现的逐页渲染文件、页面哈希和逐页人工结论；
5. 通过 `tools/Test-ArticlePublishReady.ps1` 与 `tools/Test-PublishReadyPackage.ps1`，并仅在两者均输出 `PASS — Publish Ready` 后记录最终状态。

在该示例落地前，所有 `publish_ready` 任务仍必须以实际检查器输出为准；示例不能取代发布闸门。
