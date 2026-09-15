# 上游研究包接入与预研究 Skills v1.0

> **状态：现行可选标准。** 本文件只在任务带有 SERP 简报、文章 Outline、关键词表，或用户只给出主题 + 关键词表并要求先做研究包时使用。它不改变 `workflow.json` 的阶段顺序，也不替代 `08`、`09`、Type Module、产品目录或发布闸门。

## 1. 目的与边界

上游研究包用于让文章生成有更好的起点：先理解当前 SERP 的主导页面类型、读者决策路径、内容缺口和关键词候选，再将这些材料交给既有的 `research -> plan -> content` 流程。

- 它是 `prefill_only — verify_and_refresh`，不是可直接复制进正文的结论。
- `Task Router` 仍决定唯一文章类型；`Research Passport & SERP Analyst` 仍完成当前 SERP 与竞品证据；`Fact & Product Verifier` 仍决定事实与产品可用性。
- 推荐产品是任务变量，不是 Skill。没有匹配的可验证能力、限制或来源时，产品角色必须为 `excluded`。
- `agent-reach` 是独立外部研究层，只能在用户明确要求调用 Agent-Reach 时使用；它不会自动安装依赖、读取 Cookie、登录平台或触发其他工作流。

## 2. 三种接入模式

| 模式 | 输入 | 本标准的动作 | 交给原流程的内容 |
| --- | --- | --- | --- |
| `none` | 正常任务输入 | 不运行本标准 | 原流程完全不变 |
| `topic_and_keywords` | 主题 + 关键词表；可选推荐产品 | 调用 `article-search-and-outline` 生成两份研究材料 | 简报、Outline、原始关键词表、待验证清单 |
| `supplied_package` | 用户提供简报和/或 Outline；可选关键词表 | 建立接入清单，核对时效、市场、语言、来源与冲突 | 经标记的可复用项目、刷新项目、冲突与缺失项 |

市场和语言必须来自任务或项目默认配置；缺失时不得假设。精确 Google SERP 无可用权限时，明确记录所使用的可访问搜索来源和精度限制。

## 3. Research Package Intake 输出契约

每次接入必须保存到本次任务目录 `research/`，并输出：

```yaml
name: Research Package Intake
version: 1.0
input: [topic, keyword_table, serp_brief?, article_outline?, recommended_product?]
evidence: [artifact_paths, source_dates, source_urls]
output:
  reusable: []
  refresh_required: []
  conflicts: []
  missing: []
  downstream_inputs: [keyword_candidates, intent_hypotheses, structure_hypotheses, product_claims_to_verify]
checks: [market_language_match, recency, source_traceability, type_not_preselected, product_not_preapproved]
failure_conditions: [untraceable_claims, wrong_market_or_language, material product conflict]
return_to: Task Router, Keyword & Intent Planner, Research Passport & SERP Analyst, Fact & Product Verifier
```

上游简报与 Outline 必须作为输入登记到任务运行器；过程材料留在任务 `work/` 或运行目录，不作为最终发布包的一部分，除非用户明确要求交付。

## 4. 主题 + 关键词表模式

1. 读取主题、关键词表、市场、语言和交付等级；关键词表保留原始状态，不把每个词自动写入正文。
2. 调用 `$article-search-and-outline`：产出独立的 SERP 内容策略简报与决策路径 Outline。若用户没有要求文章类型，输出“候选类型”，而非最终路由。
3. 仅当用户明确写出“调用 Agent-Reach”或“用 Agent-Reach 调研”时，再调用 `$agent-reach`；其结果仅补充可合法、已验证可用渠道的来源、日期、用户表述和场景。
4. 建立上节接入清单，标记 SERP 时效、关键词意图、产品事实与产品角色仍需在原流程复核。
5. 回到既有 `scope -> research -> plan -> content`，由原有 Skill 完成最终路由、证据、Brief、正式 Outline、文章和 QA。

## 5. 已有研究包模式

逐项检查：

| 材料 | 可复用条件 | 必须刷新或排除的情况 |
| --- | --- | --- |
| SERP 内容策略简报 | 市场、语言、检索日期、URL 和页面类型可追溯 | 日期过旧、来源不明、SERP 已变化、非目标市场 |
| Article Outline | 有明确读者路径，且与当前候选意图一致 | 与当前 SERP/类型冲突、重复拼接、无内容缺口依据 |
| 关键词表 | 保留来源、日期、意图和覆盖状态 | 无意图、跨主题、重复、词义不自然或未经市场验证 |
| 推荐产品 | 有正式 Product Catalog、官方能力与限制证据 | 无法核验、能力不相邻、角色与文章类型不匹配 |

发生冲突时，记录冲突并优先采用当前可验证证据；产品冲突遵守 `AGENTS.md` 的停止与确认规则。

## 6. 打包 Skills 与调用方式

仓库的 `skills/agent-reach/` 和 `skills/article-search-and-outline/` 是独立、显式调用的 Codex Skill 源码，不会覆盖已有全局 Skill 或任何 workflow。

- `$agent-reach`：只做用户明确请求的外部资料采集；不写文章，不调用后续内容工作流。
- `$article-search-and-outline`：只生成 SERP 内容策略简报与决策路径 Outline；不写正文，不把产品变成 Skill。
- 文章工作流收到它们的材料后，按本标准接入并验证；不直接复制，不跳过原 SOP。

## 7. 最小调用示例

```text
按文章生成工作流执行：主题为 [topic]；市场和语言沿用项目配置；关键词见附件；
先按上游研究包接入标准生成 SERP 内容策略简报和文章 Outline，
再将两份材料与关键词表交给原有内容生成流程。推荐产品为 [product]（可选）。
```

如需外部社区或视频证据，用户必须额外明确：`先调用 Agent-Reach，且仅使用当前可用、可合法读取的渠道。`
