# 多类型内容生成 Skills v1.0

## 1. 共享 Skills

| Skill | 输入 | 输出 | 失败即回流 |
| --- | --- | --- | --- |
| `Task Router` | 主题、主关键词、用户问题、SERP 线索 | 唯一 article type、理由、边界 | 类型无法判定 |
| `Keyword & Intent Planner` | 关键词表/主题、市场、语言 | Keyword Map、覆盖状态、主/次意图、排除词 | 关键词没有真实意图或被硬塞 |
| `Research Passport & SERP Analyst` | 单主题、检索环境 | SERP 前 10、3–5 个正文样本、来源、机会矩阵 | 没有本主题的正文证据 |
| `Fact & Product Verifier` | Product Catalog、官方资料、测试/案例 | 可用事实、限制、证据等级、待确认项、产品角色候选 | 将未核验信息写成事实 |
| `Content Opportunity Planner` | 意图、研究、Type Module | Brief、模块目标、内容差异化、证据回链 | Brief 不能回溯到研究 |
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

`Content Preservation Auditor` 仅用于已有文章的回审；它在任何改写、结构重排、关键词优化或视觉替换之前运行，并输出 `13_内容资产保留审计.md`。它不能以“信息更简洁”为由批准无确认的重写。
