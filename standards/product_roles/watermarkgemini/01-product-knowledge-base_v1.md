# WatermarkGemini 产品知识库 v1.0

> 资料性质：官网事实整理与内容生产调用规范  
> 核验日期：2026-08-18  
> 核验范围：WatermarkGemini 官网首页、图片工具页、隐私政策、使用条款、官方 Guides 及当前前端交互文案

## 1. 产品身份

| 字段 | 已核验内容 | 置信度 |
|---|---|---|
| 产品名称 | WatermarkGemini | 已确认 |
| 官网 | https://www.watermarkgemini.com/ | 已确认 |
| 产品类别 | 在线图片水印、Logo、文字和印章清理工具 | 已确认 |
| 产品形态 | 浏览器内使用的 Web 应用 | 已确认 |
| 操作系统 | 官网 Schema 标注为 Any；无需安装桌面软件 | 已确认 |
| 价格 | 官网标注 100% Free；无 credits 或 paid packages | 已确认 |
| 当前产品状态 | MVP；Terms 明确说明仍在评估生产图像处理提供方 | 已确认 |
| 核心定位 | 为用户自己拥有或获授权编辑的图片提供简单、私密的在线清理流程 | 已确认 |

## 2. 目标用户与适用场景

### 适用用户

- 需要清理自有图片上的可见水印、Logo、文字或印章的普通用户。
- 需要处理产品图片、演示文稿素材、个人图片的用户。
- 不想安装完整桌面编辑器、希望在浏览器中快速处理单张图片的用户。
- 需要先比较原图与结果，再决定是否下载的用户。

### 官网明确支持的场景

| 场景 | 产品对应能力 | 使用边界 |
|---|---|---|
| 移除图片中的可见水印 | 图片水印清理流程 | 只能处理用户拥有或有权编辑的图片 |
| 移除图片中的 Logo | Logo 清理页面 | 复杂或受保护的标记可能需要手动编辑 |
| 移除图片中的文字、标题、标签或印章 | 文字清理页面 | 当前工具没有手动选区画笔 |
| 移除可见 Gemini 标记 | Gemini watermark 页面 | 不处理不可见的 SynthID |
| 产品图片清理 | Logo 场景页明确提到 | 仅单张图片、格式和大小受限 |

### 不应归入当前产品能力的场景

- 视频水印移除。
- GIF 水印移除。
- PDF 水印移除。
- 批量图片处理。
- 通过 URL 直接导入图片。
- 去除不可见的 SynthID 或其他不可见来源标记。
- 对任何图片都保证无痕、完全不损失质量。

## 3. 核心能力与证据等级

| 能力 | 官网证据 | 内容写作可用表述 | 不可使用的表述 |
|---|---|---|---|
| 在线上传图片 | 首页上传工具与 How it works | “在浏览器中上传图片” | “支持所有文件类型” |
| 支持 JPG/JPEG、PNG、WEBP | 首页、各工具页 FAQ | “支持 JPG/JPEG、PNG 和 WEBP” | “支持 GIF、PDF、视频” |
| 单文件最大 10 MB | 首页和工具页 | “单张图片不超过 10 MB” | “可处理任意大小图片” |
| 自动识别可见标记 | 官网定位与工具页文案 | “用于清理可见水印、Logo、文字和印章” | “能识别所有复杂水印” |
| 原图与返回结果对比 | 首页交互与工具页 | “下载前可对比原图和结果” | “保证结果与原图完全一致” |
| 临时下载链接 | 首页与隐私政策 | “通过临时链接下载结果” | “生成永久公开链接” |
| 自动删除机制 | 首页、隐私政策 | “上传文件和结果计划在 24 小时后删除” | “上传后立即删除” |
| 免费使用 | 首页、FAQ、Terms | “当前无 credits 或付费套餐” | “永久免费且功能不会变化” |
| Google 登录门槛 | 首页 FAQ、当前前端逻辑 | “当前处理流程会要求 Google 登录” | “无需任何登录即可处理” |
| 当前 demo 处理状态 | 上传组件提示、Terms | “当前 MVP 可能返回未改变的副本” | “已验证能稳定去除水印” |

## 4. 当前实际操作流程

1. 打开官网或对应工具页。
2. 选择一张 JPG/JPEG、PNG 或 WEBP 图片，大小为 1 byte 至 10 MB。
3. 页面显示图片预览和文件名。
4. 点击 Remove watermark；当前前端交互在未登录时会打开 Google 登录提示。
5. 登录后，图片通过临时上传地址上传到私有对象存储。
6. 系统创建处理任务并轮询任务状态。
7. 完成后显示 Original 与 Result 的并排对比。
8. 通过临时下载链接下载结果，或选择 Process another 重新处理。

### 当前界面明确没有的操作

- 没有手动选区、画笔或橡皮擦。
- 没有位置、范围、强度或修复模式调节。
- 没有批量队列。
- 没有视频时间轴或移动水印跟踪。

## 5. 文件、账户与隐私知识

### 文件处理

- 上传文件进入私有对象存储，不提供永久公开 URL。
- 上传文件、结果和处理记录设计为 24 小时后过期或删除。
- 临时签名访问链接会更早过期。
- 用户应保留本地原图，并在下载前检查结果。

### 账户与登录冲突

官网隐私政策写明 MVP 不要求账户；但首页 FAQ、界面文案和当前前端逻辑显示，开始处理前会要求 Google 登录。因此该项必须标记为“待产品确认”，在文章中只能写成：

> “当前处理流程可能要求使用 Google 登录，具体以页面实际提示为准。”

### 用户责任

- 只处理自己拥有或获得授权编辑的图片。
- 不得借此伪造作者身份、规避授权或侵害知识产权。
- 不要上传机密图片或无权编辑的图片。

## 6. 产品事实调用规则

### 推荐的内容表达结构

每次推荐 WatermarkGemini 时，必须按以下顺序写：

```text
当前场景
→ 为什么常规裁剪/遮盖不理想
→ WatermarkGemini 能处理的具体图片对象
→ 具体操作步骤
→ 下载前如何检查结果
→ 格式、大小、登录和隐私限制
→ 版权与授权提醒
```

### 可直接使用的事实句

- “For a single image you own, WatermarkGemini provides a browser-based cleanup workflow for visible watermarks, logos, text, and stamps.”
- “It currently accepts one JPG/JPEG, PNG, or WEBP image up to 10 MB.”
- “Review the original and returned result side by side before downloading.”
- “The site says uploads and results are scheduled for deletion after 24 hours.”
- “The current MVP may return an unchanged copy while the production image provider is being evaluated.”

### 禁用或需确认的句子

- “Remove any watermark with one click.”
- “Works for videos, GIFs, PDFs, or batch files.”
- “Removes SynthID or invisible watermarks.”
- “Always produces a perfect, lossless result.”
- “No login is required.”
- “Your file is deleted immediately.”
- “Safe for any copyrighted or third-party image.”

## 7. 与当前文章任务的适配结论

当前 CapCut、Filmora、NotebookLM、Grok、Gamma、moving watermark 等主题主要是视频水印搜索意图，WatermarkGemini 官网当前明确只支持图片，不应作为这些视频文章的正式视频处理方法。

只有在以下情况下，才可以把 WatermarkGemini 写入文章：

- 文章对象是图片，而不是视频；或
- 产品方已确认官网已上线视频能力，并提供新的可核验页面。

在产品事实没有变化前，不能为了满足产品植入要求而把图片工具包装成视频解决方案。

## 8. 待确认项

| 项目 | 当前状态 | 后续动作 |
|---|---|---|
| 实际 AI 图像处理是否已上线 | 未确认；Terms 称仍在评估 | 产品方提供生产环境说明或测试样例 |
| Google 登录是否必需 | 官网文案存在冲突 | 产品方确认当前登录策略 |
| 免费服务的频率、并发或流量限制 | 未在公开页面说明 | 增加 FAQ 或产品规则 |
| 结果图输出格式和分辨率 | 未明确说明 | 实测或补充官方说明 |
| 复杂水印的成功率 | 未提供测试数据 | 建立内部样本测试集 |
| 数据处理区域和第三方服务商 | 未完整披露 | 补充隐私与供应商说明 |
| 视频/GIF/PDF能力 | 当前明确不支持 | 若上线需单独更新知识库与页面 |

## 9. 官方来源

- [WatermarkGemini 首页](https://www.watermarkgemini.com/)
- [Remove Gemini Watermark](https://www.watermarkgemini.com/remove-gemini-watermark)
- [Remove Logo from Image](https://www.watermarkgemini.com/remove-logo-from-image)
- [Remove Text from Image](https://www.watermarkgemini.com/remove-text-from-image)
- [Privacy Policy](https://www.watermarkgemini.com/privacy)
- [Terms of Use](https://www.watermarkgemini.com/terms)
- [How to Remove Watermarks Responsibly](https://www.watermarkgemini.com/blog/how-to-remove-watermarks-responsibly)
