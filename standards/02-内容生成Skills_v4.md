# 内容生成 Skills v5（融合版）

> 本文件定义旧入口下的正式 Skill 契约；完整职责和类型专属 Skill 清单见 `09-多类型内容生成Skills_v1.md`。文章回审 Skills 不属于本文件。

## 1. 共享 Skills：所有类型必经

| Skill | 目的 | 关键输出 | 失败时回流 |
| --- | --- | --- | --- |
| Task Router | 确认类型、市场、语言、输入完整性 | 路由结果、缺失项、必读模块 | 任务输入 |
| Keyword & Intent | 把关键词表转为真实问题与自然章节覆盖 | 意图假设、关键词状态、FAQ 问题 | 任务输入 |
| SERP & Competitor Research | 研究当前结果和内容机会 | 研究护照、样本、机会矩阵 | 意图判定 |
| Fact & Product Verification | 核验外部事实与产品能力/版本 | 来源、状态、限制、可用主张 | 产品目录/研究 |
| Product-role Decision | 判断产品是否以及如何出现 | 角色、适配理由、位置、披露 | 事实核验/类型模块 |
| Content Brief & Outline | 把证据转为文章蓝图与标题树 | Brief、唯一 H1、模块验收项 | 研究或角色决策 |
| Drafting | 依批准 Brief 完成文章 | 草稿、证据标记、视觉需求 | Brief/大纲 |
| Generation QA & Handoff | 生成端自检并交给回审流程 | QA 清单、未决项、交接包 | 对应责任 Skill |

所有 Skill 统一输出：`input`、`evidence`、`decision`、`output`、`checks`、`failure_conditions`、`return_to`。没有证据的结论必须标记不确定性，而不是由正文补猜。

## 2. 类型专属 Skills：按路由调用

| 类型 | 必须额外调用 | 核心限制 |
| --- | --- | --- |
| How-to | Solution Research、Method Decision、Step Design | 方法由候选池决定，产品只在直接匹配时为正式 Method |
| Top | Candidate Scope、Evaluation Matrix、Ranking Rationale | 无测试数据不得伪称实测或预设第一名 |
| VS | Comparison Scope Lock、Dimension Comparison、Verdict Logic | 锁定版本/地区；允许结论为“取决于场景/证据不足” |
| 泛主题 | Topic-mode Selection、Entity/Scenario Mapping | 先确定解释、趋势、实体指南或问题背景模式 |
| Alternatives | Replacement-need Map、Substitutability Assessment、Migration Check | 先解释为何替代，不能只罗列竞品 |
| What Is & Specs | Definition First、Specification Normalization、Boundary Check | 先直接定义；规格必须带来源、单位、版本和边界 |

## 3. 产品角色决策

产品角色不是固定广告位，必须由类型、主任务和证据决定：

- `formal_method`：仅 How-to 中直接完成主任务的正式方案。
- `ranked_candidate`：Top 中满足入选和评估规则的候选对象。
- `comparison_subject`：VS 中被公平比较的对象，不预设胜方。
- `implementation_tool`：泛主题或 What Is 中帮助用户落地的可选工具，不替代核心解释。
- `ultra_tip`：主任务完成后的真实相邻需求补充，清楚说明不适用范围。
- `excluded`：无关、证据不足、版本不匹配或有误导风险；不出现在文章中。

## 4. 共同失败条件

- 没有市场/语言便开始 SERP 或使用旧研究结果替代当前研究。
- 将关键词表当作必须逐条塞入正文的清单。
- 将产品名、历史排名、旧模板当作结论依据。
- 不区分事实、判断和示例；虚构测试、数据、案例或用户反馈。
- 正文阶段临时改变已批准的产品角色、结构或类型。
- 用生成端 QA 代替独立的文章回审流程。
