# 多类型内容生成 Skills v1.0

## 1. 共享 Skills

| Skill | 输入 | 输出 | 失败即回流 |
| --- | --- | --- | --- |
| `Research Package Intake`（可选） | 主题、关键词表、上游 SERP 简报/Outline、推荐产品变量 | 接入清单、复用/刷新/冲突判定、待验证项与正式下游输入 | 把上游结论当作事实、路由或产品角色的替代品 |
| `Task Router` | 主题、主关键词、用户问题、SERP 线索 | 唯一 article type、路由证据卡、边界 | 用产品、次级词或商业目标替代主查询意图 |
| `Keyword & Intent Planner` | 关键词表/主题、市场、语言 | Keyword Map、覆盖状态、主/次意图、排除词 | 关键词没有真实意图或被硬塞 |
| `Research Passport & SERP Analyst` | 单主题、检索环境 | SERP 前 10、3–5 个正文样本、来源、机会矩阵 | 没有本主题的正文证据 |
| `Fact & Product Verifier` | Product Catalog、官方资料、测试/案例 | 可用事实、限制、证据等级、待确认项、产品角色候选、实时官方证据复核记录 | 将未核验信息写成事实，或只凭 Catalog/历史资料将产品排除 |
| `Content Opportunity Planner` | 意图、研究、Type Module | Brief、模块目标、内容差异化、证据回链 | Brief 不能回溯到研究 |
| `Reference Pattern Analyst`（可选） | 已完成的当前 SERP/竞品研究、外部案例库 | 抽象可用模式、显式排除项、差异化决策与反同质化审计 | 案例预设类型/结构/产品，或复制案例内容 |
| `Visual Requirements Planner` | 大纲、用户场景、素材 | 图片位置、目的、画面、避免元素、Alt | 只有通用或文字化配图 |
| `Cross-type QA & Handoff` | 初稿与全部上游产物 | 通过/失败、正文位置证据、回流点、交接包 | 无证据评分或缺少核心产物 |
| `Content Preservation Auditor` | 原文、用户回审请求、原文图片/表格/来源 | 回审模式、资产台账、保留率、压缩/替换确认 | 未经确认重写、压缩或删除有效资产 |

## 2. 专属 Skills

| Type Module | 专属 Skill | 关键输出 |
| --- | --- | --- |
| How-to | `Method Matrix Designer` | 候选方案、场景、步骤、限制、方法排序与产品角色 |
| Top 评测 | `Evaluation & Ranking Designer` | 入选门槛、可比维度、证据等级、排名和未入选理由 |
| VS | `Decision Comparison Designer` | 对比维度、按场景的胜者、平局/不确定项和测试设计 |
| 泛主题 | `Topic Narrative & Entity Mapper` | 子意图、实体关系、信息边界、读者路径与可选工具位置 |
| Alternatives | `Alternative Set Designer` | 原产品痛点、纳入/排除条件、替代类别、场景匹配与排序 |
| What Is & Specs | `Definition & Specification Modeler` | 可引用定义、术语、规格表、单位、类型、误区和应用边界 |

## 3. 输出契约

每个 Skill 均输出：`name`、`version`、`purpose`、`input`、`evidence`、`output`、`checks`、`failure_conditions`、`return_to`。

Skills 只能输出自己确有证据支持的内容。对产品、价格、测试、社区反馈或时间敏感资料，必须附来源和核验日期；没有证据时返回“研究不完整”，而不是补写看似合理的结论。

当产品可能因对象、格式、版本或模块不匹配而被标为 `excluded` 时，`Fact & Product Verifier` 必须先输出 `real_time_official_verification`：`checked_at`、官方产品页 URL、官方指南/支持页 URL、对象/格式专页 URL（如有）、支持/不支持摘录、Catalog 冲突、结论。只有该记录确认不支持或不相邻，才允许 `excluded`；官方页面相互矛盾时返回 `research_incomplete`，不得假定不支持。

`Research Package Intake` 可以调用仓库中打包的 `article-search-and-outline`，并且仅在用户明确要求 Agent-Reach 时调用 `agent-reach`。它不能调用、替换或重命名用户的其他 SEO、内容或 GEO Skill；推荐产品永远是任务变量，必须继续经过 `Fact & Product Verifier` 和 Type Module 的角色判定。

`Reference Pattern Analyst` 只在用户或项目明确提供外部案例库时调用，且只能在 `Research Passport & SERP Analyst` 之后运行。它不写正文、不提取可复用文案、不将案例事实升级为证据。它输出的是“可参考的信息关系”和“不可复用项”，并要求当前文章在结构、逻辑、内容增量和产品位置上保持独立。

`Content Preservation Auditor` 仅用于已有文章的回审；它在任何改写、结构重排、关键词优化或视觉替换之前运行，并输出 `13_内容资产保留审计.md`。它不能以“信息更简洁”为由批准无确认的重写。
