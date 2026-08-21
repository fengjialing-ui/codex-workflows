# WatermarkGemini 产品角色入口

> 本文件是 WatermarkGemini 在内容生产流程中的产品角色入口。
> 内容 Agent / Codex 在决定是否植入 WatermarkGemini 前，应优先读取本文件。

---

## 1. 产品身份

- Product: WatermarkGemini
- Website: https://www.watermarkgemini.com/
- Product Type: Browser-based Image Watermark Remover
- Current Status: MVP
- Primary Object: Image

核心用途：

- Remove visible watermarks from images
- Remove logos from images
- Remove text / stamps from images
- Remove visible Gemini watermark from images

---

## 2. 当前产品能力边界

### Supported

- JPG / JPEG
- PNG
- WEBP
- Single image
- Maximum 10 MB
- Visible watermark
- Visible logo
- Visible text
- Visible stamp

### Not Supported

- Video watermark removal
- GIF watermark removal
- PDF watermark removal
- Batch image processing
- Invisible watermark removal
- Google SynthID removal
- Guaranteed lossless / perfect watermark removal

---

## 3. 内容植入角色判断

WatermarkGemini 是否进入文章，必须先根据文章实际任务判断。

### formal_method

只有当 WatermarkGemini 的当前产品能力能够直接解决用户搜索需求时，
才允许作为正式解决方案进入 Methods。

典型场景：

- remove watermark from image
- remove logo from image
- remove text from image
- remove visible Gemini watermark from image
- image watermark remover

---

### ultra_tip

当文章核心任务不是 WatermarkGemini 的直接能力，
但用户可能存在额外的图片水印处理需求时，
可以作为补充推荐出现。

表现形式包括：

- Ultra Tip
- Bonus Tip
- Alternative
- Additional solution

Ultra Tip 不计入正式 Methods 数量。

---

### excluded

当文章任务超出当前 WatermarkGemini 产品能力时，
禁止将其作为解决方案植入。

包括：

- video watermark removal
- CapCut video watermark
- Filmora video watermark
- moving watermark from video
- GIF watermark
- PDF watermark
- invisible watermark / SynthID
- batch watermark removal

不得为了满足产品植入要求，
将图片工具包装成视频或其他不支持场景的解决方案。

---

## 4. Agent 判断流程

在考虑使用 WatermarkGemini 时：

1. 判断用户实际需要处理的对象。
2. 判断对象是否为图片。
3. 判断 WatermarkGemini 当前能力是否直接解决该问题。
4. 判断产品角色：
   - 直接解决 → formal_method
   - 仅作为相关补充 → ultra_tip
   - 无法解决 → excluded
5. 确认角色后，再读取对应产品资料。
6. 所有产品功能、参数和限制必须来源于产品知识库，不得自行推断。

---

## 5. 文件调用规则

### 需要确认产品事实时

读取：

`01-product-knowledge-base_v1.md`

用于确认：

- 产品能力
- 支持格式
- 文件大小
- 登录要求
- 隐私规则
- 产品状态
- 支持 / 不支持场景
- 官方证据
- 待确认项

---

### 需要写入文章时

读取：

`02-product-usage-whitepaper_v1.md`

用于确认：

- 什么情况下推荐产品
- 产品如何进入文章
- 操作步骤如何描述
- 推荐话术
- 必须披露的限制
- 禁止使用的营销表述
- 场景化使用方式

---

## 6. 信息优先级

发生信息冲突时，按照以下优先级处理：

1. 当前官网实际产品能力
2. 最新产品知识库
3. 最新产品使用白皮书
4. 旧文章或历史内容

不得使用旧文章中的产品描述覆盖最新产品事实。

---

## 7. 强制规则

- 不得虚构官网不存在的产品能力。
- 不得为了完成产品植入而改变用户真实解决方案。
- 不得把 WatermarkGemini 写成视频水印工具。
- 不得宣称支持 SynthID 或其他不可见水印移除。
- 不得承诺 100% 成功、无损或完美去除。
- 产品存在事实冲突时，以产品知识库中的“待确认”状态处理。
- 无法确认的产品能力不得作为事实写入文章。

---

## 8. 当前资料

| 文件 | 用途 |
|---|---|
| `README.md` | 产品角色判断与资料路由 |
| `01-product-knowledge-base_v1.md` | 产品事实 Source of Truth |
| `02-product-usage-whitepaper_v1.md` | 内容植入与产品使用规范 |

---

## 9. 更新规则

当产品能力发生变化时：

1. 先更新产品知识库；
2. 再更新产品使用白皮书；
3. 如果产品支持范围发生变化，同步更新本 README 的角色规则；
4. 更新版本号与核验日期；
5. 旧规则不得继续作为当前内容生产依据。
