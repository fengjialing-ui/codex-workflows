# Product Catalog Schema v1.0

本文件定义所有文章类型接收产品信息的统一格式。它用于支持不同产品，不把任何品牌设为默认推荐对象。

## 每个产品的必填字段

```yaml
products:
  - product_id: unique-slug
    name: Product name
    url: https://example.com/
    ownership: own | partner | third_party
    content_objects: [image, video]
    core_tasks:
      - task the product directly completes
    supported_capabilities:
      - capability with an official source
    limitations:
      - unsupported object, workflow, format, policy, or quality boundary
    requirements:
      - format, size, platform, account, pricing, privacy, or version requirement
    approved_sources:
      - https://example.com/help
    available_evidence:
      - official documentation | verified test | approved case study
    verification_status: verified | partially_verified | pending
    verified_at: 2026-08-21
    article_role_candidates:
      - formal_method | ranked_candidate | comparison_subject | implementation_tool | ultra_tip
    cta_url: https://example.com/
```

## 使用规则

1. 没有结构化资料或可核验来源的产品，默认 `excluded`。
2. 产品角色由当前主题的内容对象、核心任务、文章类型与证据决定；可用角色见 `08-多类型文章调度与共享标准_v1.md`。
3. 产品名称、功能、限制、链接和 CTA 必须来自本次 Catalog；不得从前一篇文章复制。
4. How-to 的 `formal_method` 必须直接完成当前主任务，进入方法矩阵和比较表；Top/Alternatives 的 `ranked_candidate`、VS 的 `comparison_subject` 也必须按同一事实标准核验。
5. `ultra_tip` 只能解决主任务完成后的相邻需求，必须披露不适用范围，且不计入方法、榜单或对比结论。
6. 多个产品可同时进入候选池；不要求每篇文章使用产品，也不允许为推广而制造场景。
7. `verification_status` 不是宣传词：`pending` 或 `partially_verified` 的能力、价格、性能和案例不得被写成确定结论。
