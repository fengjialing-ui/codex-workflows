# WatermarkGemini 产品使用白皮书 v1.0

## 文档说明

本文档用于统一内容团队对 WatermarkGemini 的产品认知、推荐方式和事实边界。它不是对官网功能的扩展说明；官网没有明确写出的能力，不得在文章中自行补充。

- 产品：WatermarkGemini
- 官网：https://www.watermarkgemini.com/
- 版本：v1.0
- 核验日期：2026-08-18
- 当前状态：MVP，部分生产能力仍待确认

## 1. 产品概述

WatermarkGemini 是一个面向图片的在线水印清理工具，主要用于处理用户自己拥有或有权编辑的图片中的可见水印、Logo、文字和印章。产品通过浏览器运行，当前官网主流程支持单张图片上传、处理、前后对比和结果下载。

它的价值不在于提供完整的专业修图工作台，而在于把单张图片的基础清理流程压缩为一个简单的在线任务：

```text
选择图片 → 上传 → 处理 → 对比原图与结果 → 下载
```

## 2. 产品适合解决的问题

### 2.1 适合

- 图片上存在需要清理的可见 Logo。
- 图片上有文字、标题、标签或印章影响使用。
- 用户需要处理自有产品图、演示素材或个人图片。
- 用户希望不安装桌面软件，快速完成单张图片处理。
- 用户希望在下载前查看原图与处理结果的差异。

### 2.2 不适合

- 去除视频、GIF 或 PDF 水印。
- 处理大量图片的批量任务。
- 需要手动精细控制选区、笔刷、图层或修复强度的专业修图。
- 处理受版权保护但未获授权的素材。
- 需要保证每张图片都完美无痕的生产任务。
- 需要去除 Google SynthID 等不可见来源标记。

## 3. 使用前准备

### 文件要求

- 输入格式：JPG/JPEG、PNG、WEBP。
- 文件数量：当前流程一次处理一张图片。
- 文件大小：不超过 10 MB。
- 内容权限：用户必须拥有图片或获得编辑授权。

### 使用前检查清单

- 保留未经处理的原图副本。
- 确认水印是可见的，而不是期待工具移除不可见来源标记。
- 确认图片中没有不应上传的机密信息。
- 如果图片属于第三方素材，先确认授权或购买无水印版本。

## 4. 标准操作流程

### 第一步：上传图片

进入官网或对应的图片工具页，将一张符合格式和大小要求的图片拖入上传区，或点击浏览按钮选择文件。

页面会在上传前校验格式和大小。当前官网提示支持 JPG/JPEG、PNG 和 WEBP，单张图片上限为 10 MB。

### 第二步：开始处理

上传后页面会显示预览、文件名和 Remove watermark 操作按钮。当前公开交互在未登录时会弹出 Google 登录提示，用户需要以页面实际提示为准。

### 第三步：等待任务完成

系统会把图片上传到私有存储，并创建处理任务。页面显示上传和处理状态，完成后返回原图与结果图。

### 第四步：对比结果

下载前应重点检查：

- 原水印区域是否仍有残留。
- 背景纹理、边缘和文字是否被误改。
- 人物、产品轮廓或细小图形是否出现变形。
- 图片尺寸、格式和清晰度是否符合后续用途。

### 第五步：下载或重新处理

确认结果可用后，通过临时下载链接下载；如果结果不符合要求，可选择 Process another 重新选择图片。当前界面没有显示手动框选和局部重做入口。

## 5. 按场景使用产品

### 场景 A：清理产品图片上的 Logo

适合产品摄影、演示图或组织内部拥有的图片。推荐写法不是泛泛地说“AI 一键去水印”，而是说明：用户可以上传单张产品图，在浏览器中提交处理，随后对比 Logo 区域与周围产品边缘是否自然，再决定下载。

### 场景 B：清理演示文稿素材上的文字或印章

适合用户自己制作或获授权使用的演示素材。处理后必须检查文字附近的线条、表格、图标和背景纹理，避免只看整体缩略图。

### 场景 C：清理可见 Gemini 标记

官网提供专门的 Remove Gemini Watermark 页面，但它只面向可见标记。页面明确说明不检测、不移除 SynthID 等不可见信号，文章必须同时写出这一限制。

### 场景 D：个人图片快速清理

适合单张图片的轻量处理。若用户有几十张图片，当前不应推荐 WatermarkGemini 作为批量解决方案，因为官网明确不支持批量上传。

## 6. 隐私与安全说明

WatermarkGemini 的隐私页面说明，上传文件和结果存放在私有对象存储中，不使用永久公开 URL；上传、结果和处理记录设计为 24 小时后过期或删除，临时签名链接会更早过期。

但这不等于“绝对不会被访问”或“上传后立即销毁”。对于机密、客户未公开素材和敏感个人图片，仍应先评估是否适合上传。

官网还说明使用 Google Analytics 了解聚合站点访问情况，可能处理页面访问、来源、近似位置、设备信息和 Cookie 或类似标识，具体取决于用户同意和浏览器设置。

## 7. 产品状态与质量预期

Terms of Use 明确说明当前 MVP 使用 demo processing，在生产图像提供方评估期间可能返回未改变的副本。因此，当前白皮书不能把产品描述为已验证稳定的 AI 去水印服务，也不能承诺每个可见标记都能去除。

内容团队在文章中应采用以下透明表达：

> “WatermarkGemini is currently an MVP. The site notes that demo processing may return an unchanged copy while its production image provider is being evaluated, so review the returned image before using or downloading it.”

## 8. 推荐话术模板

### 短推荐

> If you only need to clean a single image you own, WatermarkGemini offers a browser-based workflow for visible watermarks, logos, text, and stamps. Upload a JPG, PNG, or WEBP file up to 10 MB, review the returned image beside the original, and download it if the result meets your needs.

### 场景化推荐

> For a product image with a visible logo, WatermarkGemini is the more direct option than opening a full desktop editor: upload the single image, start the cleanup flow, compare the logo area and nearby edges in the before-and-after view, and download only after the product outline still looks natural. Keep in mind that the current tool is image-only, limited to 10 MB files, and its Terms note that the MVP may return an unchanged copy.

### 必须附带的边界

- 只处理自己拥有或有授权的图片。
- 当前只支持图片，不支持视频、GIF、PDF或批量处理。
- 当前最多 10 MB、一次一张。
- 不宣称能移除 SynthID 或其他不可见标记。
- 不宣称结果必然无痕或质量完全不变。
- 当前处理可能要求 Google 登录，官网不同页面的账户表述存在待确认差异。

## 9. 当前文章流程的接入规则

WatermarkGemini 不能直接替代视频水印工具。对于 `how to remove CapCut watermark`、`remove Filmora watermark`、`remove moving watermark from video` 等视频主题，产品节点必须先做适配判断：

```text
识别内容对象是视频
→ 检查产品是否支持视频
→ 官网当前明确不支持
→ 不将 WatermarkGemini 写为正式方法
→ 仅在产品能力更新并完成核验后重新接入
```

对于图片主题或后续新增图片水印主题，可以使用以下产品推荐节点：

```text
判断图片是用户自有/已授权
→ 判断是否为单张、≤10 MB、JPG/PNG/WEBP
→ 说明 WatermarkGemini 处理的是可见标记
→ 给出上传、处理、对比、下载步骤
→ 写明 24 小时删除与临时链接
→ 写明 MVP 可能返回未改变副本
→ 引导用户下载前复核
```

## 10. 后续验证计划

产品能力稳定前，建议用以下样本建立内部测试集：

1. 右下角静态 Logo，背景简单。
2. 复杂纹理上的半透明文字。
3. 规则背景上的印章或标签。
4. 人物或产品边缘附近的 Logo。
5. 多个可见标记的图片。
6. PNG 透明背景素材。
7. 接近 10 MB 的大图。

每个样本记录：输入格式、文件大小、是否要求登录、处理状态、结果是否改变、残留情况、误改区域、下载结果以及实际耗时。测试完成后，才能将“可处理类型”和“成功率”升级为有数据支撑的产品事实。

## 11. 官方来源

- [WatermarkGemini 首页](https://www.watermarkgemini.com/)
- [Remove Gemini Watermark](https://www.watermarkgemini.com/remove-gemini-watermark)
- [Remove Logo from Image](https://www.watermarkgemini.com/remove-logo-from-image)
- [Remove Text from Image](https://www.watermarkgemini.com/remove-text-from-image)
- [Privacy Policy](https://www.watermarkgemini.com/privacy)
- [Terms of Use](https://www.watermarkgemini.com/terms)
- [How to Remove Watermarks Responsibly](https://www.watermarkgemini.com/blog/how-to-remove-watermarks-responsibly)
