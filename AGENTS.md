# Codex 内容生产工作流

本仓库是内容生产的正式标准库。执行任何内容生成、改稿、SEO 或竞品分析任务前，必须先遵守本文件。

## 开始任务

1. 阅读 `brief.md` 与 `STATUS.md`，确认本次任务、已有资料和当前进度。
2. 阅读 `standards/README.md`，确定需要调用的正式 SOP。
3. 所有新建文章必须阅读：
   - `standards/08-多类型文章调度与共享标准_v1.md`
   - `standards/09-多类型内容生成Skills_v1.md`
   - 一个由文章类型决定的 Type Module（见 `standards/types/README.md`）
   - `standards/05-竞品内容分析标准_v1.md`
   - `standards/product_roles/PRODUCT_CATALOG_SCHEMA.md`（任务提供产品时）
4. 使用具体产品时，还必须阅读该产品目录下的当前知识库和使用白皮书。
5. `01` 至 `05` 是保留旧路径的融合版正式入口；执行时仍以 `08` 的路由和对应 Type Module 为先。
6. `standards/06-How-to流程问题归因与升级说明_v1.md` 仅解释迁移背景，不能作为执行规则。

## 执行规则

- 当前批准的文章类型仅限 How-to、Top 评测、VS、泛主题、Alternatives 与 What Is & Specs；其他类型必须先新增并批准对应的 Type Module。
- 先完成调研、搜索意图和方案决策，再确定文章结构与正文；不得预设 Methods 数量、顺序或产品位置。
- 产品必须先按 `formal_method`、`ultra_tip` 或 `excluded` 判定；不得在正文完成后追加广告段落。
- 未核验的产品事实、参数、价格、案例、结果或来源，不得写成确定事实。
- 不满足标准中的阻断条件时，停止交付并说明缺失资料或需要返工的环节。
- 最终交付物保存到 `outputs/`；过程材料与临时文件保存到 `work/`，不上传到仓库。

## 完成与交接

1. 更新 `STATUS.md`：已完成阶段、交付物路径、待确认事项和下一步。
2. 在 `outputs/` 中保留最终交付物及必要的验证记录。
3. 不把密码、密钥、个人令牌或登录信息写入或上传到仓库。

## 换电脑后

打开仓库后，先阅读本文件、`brief.md`、`STATUS.md` 和标准库索引，再继续工作。

