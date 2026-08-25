# HitPaw FotorPea 产品知识库 v1.0

> 资料性质：内部产品白皮书与当前 HitPaw 官方页面的交叉整理。  
> 当前核验日期：2026-08-25  
> 可用状态：`partially_verified`。当前官网可验证事实可用于文章；产品页面的宣传效果、用户案例及内部历史数据不能当作客观表现承诺。

## 1. 产品身份

| 字段 | 当前可用事实 | 证据状态 |
| --- | --- | --- |
| 产品名称 | HitPaw FotorPea | 当前官网已核验 |
| 曾用名称 | HitPaw Photo Enhancer | 当前官网已核验 |
| 核心对象 | 图片 | 当前官网已核验 |
| 产品形态 | Windows / macOS 下载软件；官网也展示在线、iOS、Android 或插件入口，功能与计划需分别确认 | 当前官网已核验；平台范围待当次核验 |
| 核心定位 | AI 图片增强、编辑与生成工具 | 当前官网已核验 |
| 内容对象 | 低清、模糊、暗光、噪点、旧照片、人像、文字、插画及需要编辑的图片 | 官网及内部资料交叉核验 |

## 2. 当前可写能力

| 能力 | 可写表述 | 文章边界 |
| --- | --- | --- |
| 图片增强与放大 | “FotorPea provides AI photo-enhancement workflows for low-resolution, blurry, and damaged images.” | 输出分辨率、模型、计划与平台动态变化；不承诺保真 |
| 人脸增强 | 官网展示 Face Model 和人像修复路径 | 不保证身份、年龄、皮肤纹理或真实细节 |
| 模糊修复 | 官网展示针对手抖、运动、失焦等 blur types 的增强表述 | 复杂运动／失焦仍可能产生错误，不能作结果保证 |
| 多模型增强 | 内部白皮书列出通用、人脸、降噪、去镜头模糊、去运动模糊、去压缩、文字、动漫、上色、暗光、划痕与颜色校正等模型；当前官网展示 AI Enhancer、Face、Upscale、Text、Low-light 等路径 | 文章只写当前版本界面与官方指南确认存在的模型；内部模型名作为待确认线索 |
| 旧照片修复与上色 | 当前官网与更新页列出 old-photo restoration / colorization | 上色、生成式修复会解释性重建像素，不是历史事实证明 |
| AI 图像生成、编辑与 Canvas | 官网列出 prompt-based editing、AI image generator、AI Canvas / chat drawing | 不把生成图当成摄影原件；模型和版权／商用条款需单独核验 |
| 背景移除 | 官网列出 background removal | 边缘、头发、透明物体和复杂主体需要人工复查 |
| 对象移除 | 官网将 remove objects 列为图片编辑能力；内部白皮书明确把水印列入对象移除场景 | “水印”具体支持范围、批量与效果需要当前版本验证；只能处理自有或获授权图片 |
| 文本与暗光处理 | 当前官网更新页列出 Text / Low-light 模型 | 字体、文档、文字准确性不可保证；重要文本必须人工比对 |
| 批处理 | 当前更新页和 Mac 产品页提及批量增强 | 当前平台、计划、文件限制必须当次确认 |

## 3. 文件、系统与商业字段

| 字段 | 当前状态 | 写作规则 |
| --- | --- | --- |
| 系统要求 | 当前官方 getting-started 指南展示 Windows 10/11、macOS 13+ 及分级配置 | 不在常青文章硬编码配置；链接当次官方指南 |
| 操作流 | 官网产品页示范 Launch & Upload → Select AI Model → Preview & Export | 当前产品 UI 与功能名称需当次确认 |
| 价格和 Credits | 当前官方购买页显示月／年／永久计划、Credits 和功能差异 | 高度动态；只有购买型内容可当日引用官方购买页 |
| 免费／预览限制 | 购买页区分免费与付费权益 | 不用“免费”“无水印预览”或额度作永久承诺 |
| 数据处理与隐私 | 官网页面与不同平台条款可能不同 | 不作“立即删除”“绝不上传”“完全安全”承诺；核对隐私政策和实际模块 |

## 4. 已知限制与风险

- 放大、去噪、锐化、生成性增强、对象移除和上色都可能重绘或错误补全细节；必须检查重要文字、脸部、产品边缘、标志和纹理。
- 高分辨率、批处理、AI 生成或高级编辑能力可能依赖 Credits、套餐、网络或平台。
- 对象移除不等于拥有图片、移除归属或绕过许可证的权利。
- 对重要证据、医学／法律／新闻图片或历史档案，不要把 AI 处理结果视作未经修改的原件。
- 当前官网的最大分辨率存在不同页面描述（例如 8K、16K、32K）；不可在正文中选择一个固定数值，除非当次路径和计划已经核验。

## 5. 产品目录记录（可复制到 Brief）

```yaml
products:
  - product_id: hitpaw-fotorpea
    name: HitPaw FotorPea
    url: https://www.hitpaw.com/fotorpea-photo-enhancer.html
    ownership: third_party
    content_objects: [image]
    core_tasks:
      - AI photo enhancement, upscaling, denoising, deblurring, and restoration
      - image editing, background removal, and object removal where available
    supported_capabilities:
      - Model-based image enhancement with preview and export
      - Face, upscale, old-photo, text, low-light, generation, and editing paths where available
    limitations:
      - Results vary by image, model, plan, and platform
      - Current pricing, credits, output limits, supported models, and privacy terms require publication-date verification
      - Do not use for unauthorized attribution or copyright-marker removal
    requirements:
      - Keep the original and inspect the full-size result before use
      - Confirm current model and object-removal scope in the product build
    approved_sources:
      - https://www.hitpaw.com/fotorpea-photo-enhancer.html
      - https://www.hitpaw.com/ai-photo-editor.html
      - https://www.hitpaw.com/guide/hitpaw-fotorpea-get-started.html
      - https://www.hitpaw.com/whats-new/hitpaw-fotorpea-updates.html
      - https://online.hitpaw.com/purchase/buy-hitpaw-fotorpea.html
    available_evidence: official documentation plus internal product whitepaper
    verification_status: partially_verified
    verified_at: 2026-08-25
    article_role_candidates: [formal_method, ultra_tip]
    cta_url: https://www.hitpaw.com/fotorpea-photo-enhancer.html
```

## 6. Source ledger

| Source | Type | How it is used |
| --- | --- | --- |
| `D:/Users/Desktop/AI自动化/内容生成/产品知识库/fotorpea产品使用白皮书.docx` | Internal historical product whitepaper, updated through 2025-09-09 | Scenario, model and workflow context; dynamic facts not carried forward without current official confirmation |
| `D:/Users/Desktop/AI自动化/内容生成/产品知识库/产品核心功能内容数据收集.xlsx` | Internal research / promotion data | Scenario and source discovery only; no performance or review claim adopted as fact |
| https://www.hitpaw.com/fotorpea-photo-enhancer.html | Current official product page | Product identity, current enhancement paths and basic workflow |
| https://www.hitpaw.com/ai-photo-editor.html | Current official product page | Editor, generation, background and object-removal positioning |
| https://www.hitpaw.com/guide/hitpaw-fotorpea-get-started.html | Current official guide | Current system requirements and getting-started route |
| https://www.hitpaw.com/whats-new/hitpaw-fotorpea-updates.html | Current official update log | Recent model, batch and editor changes |
| https://online.hitpaw.com/purchase/buy-hitpaw-fotorpea.html | Current official purchase page | Dynamic plan, Credit and feature-access check only |

## 7. Items requiring fresh verification

- Current version and per-platform (desktop, online, mobile, plugin) feature availability.
- Supported files, dimensions, batch limits, exact export options and maximum resolution.
- Current price, taxes, renewal, Credits, trial, free export, plan entitlements and region.
- Current data handling, retention, network processing and privacy terms.
- Any performance multiple, timing, success rate, comparison, user quote, ranking or “best” claim.
- The exact current behavior of object / watermark removal, including selection controls and limitations.
