# HitPaw FotorPea 产品使用白皮书 v1.0

> 用途：规范 HitPaw FotorPea 在新文章中的角色、操作说明、事实披露与风险边界。  
> 当前核验日期：2026-08-25。

## 1. 适合进入正文的场景

FotorPea 适用于图片任务：低清或模糊图片增强、图片放大、噪点／压缩／暗光／文字改善、旧照片修复和上色、背景移除、图片对象移除、AI 图片生成与编辑。只有当它直接解决文章的图片主任务，才作为 `formal_method`；仅为相关的单图补充需要时，使用 `ultra_tip`。

典型适配：

- 自有或获授权的照片、产品图、设计图、插画或旧照片需要质量修复；
- 读者需要一个“上传 → 选模型 → 预览 → 导出”的低门槛图片工作流；
- 图片中有需移除的非归属性杂物，且结果可人工检查；
- 文章有明确的图片处理对象，而不是视频或 PDF。

不适配：视频文章、需要逐帧时间线控制的任务、未授权图片、需要保存原始证据的图像，或要求每个细节都不能被 AI 重绘的场景。

## 2. 标准写作结构

```text
明确图片问题和授权边界
→ 为什么原图、重新导出或手动编辑仍是优先选择
→ FotorPea 的相关当前模型／功能
→ 准备条件与限制
→ 导入 → 选择模型或编辑路径 → 预览 → 全尺寸检查 → 导出
→ 对文字、脸、边缘和颜色的结果复核
→ 优点、限制、价格／Credits／隐私的当次核验提示
```

每个正式方法均需要：一句结论、`Best for`、不适用范围、准备条件、步骤、结果检查、优点和限制。产品不能取代读者的核心判断。

## 3. 当前可用的通用操作表述

在发布当天确认界面后，可使用下列不依赖旧版本号的流程：

1. 复制并保存原图；不要在唯一文件上覆盖。
2. 导入一张代表性图片，先确定问题是低分辨率、噪点、压缩、失焦、运动模糊、暗光、老照片、文字、背景还是待移除对象。
3. 在当前 AI Enhancer 或编辑模块中选择与问题相符的模型／功能。不要为了“更清晰”叠加多个模型而没有比较依据。
4. 先运行预览，放大检查人物五官、发丝、文字、产品边缘、图标、渐变和重复纹理。
5. 对对象移除，仅选择一个非关键且授权清楚的区域；如果结果改变了作者归属、产品信息、证据内容或重要文字，应停止使用该结果。
6. 导出测试文件，检查最终尺寸、格式、色彩、透明度与压缩质量；与原图并排保存。
7. 有多图需求时，先用代表性样本确认模型和计划限制，再决定是否使用当前的批处理功能。

## 4. 图片去水印／对象移除的额外边界

内部白皮书把水印列为对象移除的可能场景，当前官方编辑页把对象移除列为产品能力。正文只能在以下条件同时满足时写入：

- 图片由读者拥有或已取得明确编辑授权；
- 当前产品版本中对象移除模块确实可用，且本次已核验其操作和限制；
- 水印不是第三方作者署名、版权声明、许可证信息或需要保留的来源标识；
- 输出结果经人工检查，且没有误改人物、产品、文字和背景事实。

不得写：任何图片一键无痕去水印、可移除任何标记、绝不影响质量、可处理不可见来源标记，或以像素编辑暗示权利转移。

## 5. 推荐话术

### 简短、事实优先

> HitPaw FotorPea is an AI photo-enhancement and editing application for images that need upscaling, restoration, blur or noise cleanup, and selected editing tasks. Keep the original, select the model that matches the visible issue, preview the result, and inspect the exported image at full size before using it.

### 场景化

> For an authorized low-resolution product photo, FotorPea can be a practical model-based workflow: import one representative image, select the currently available enhancement path, compare the preview with the original, and inspect edges, labels, and texture before export. Confirm the current output limit, plan, and Credit conditions in the product at publication time.

### 对象移除

> For a non-essential object in an image you own, FotorPea’s current product positioning includes object-removal editing. Use the smallest possible selection and review the returned pixels at full size. It is not appropriate for removing another creator’s attribution or for images where a reconstructed area would change the meaning of the image.

## 6. 禁用或必须降级的表述

| 不可用表述 | 合规替代 |
| --- | --- |
| “FotorPea restores every detail perfectly / losslessly.” | “Review the preview and exported image at full size.” |
| “It is the fastest / best photo enhancer.” | 基于具体图片与工作流描述适配，不做无证排名。 |
| “Works for all formats, resolutions, and platforms.” | 发布时核验当前路径和限制。 |
| “Free unlimited enhancement / fixed price / fixed Credits.” | 动态字段仅引用当日官方购买页。 |
| “Remove any watermark or source label.” | 只描述已授权的非归属性对象处理，并披露限制。 |
| “AI restoration proves what the original looked like.” | 说明它可能重建像素，重要事实需回到原件。 |

## 7. Article QA checklist

- [ ] 文章对象为图片，产品角色与核心意图匹配。
- [ ] 先说明源图、重新导出或手动编辑等更保真的选择。
- [ ] 当前模型、批处理、文件限制、平台、计划、Credits 和隐私已当次核验。
- [ ] 没有将内部性能数据、用户案例或营销主张写成独立事实。
- [ ] 涉及对象／水印移除时已写入授权、归属、伪影和全尺寸检查边界。
- [ ] 生成、上色、增强的结果未被称作未经修改的历史或摄影事实。
