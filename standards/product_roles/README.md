# 产品知识库与文章角色规则

每个产品使用独立目录保存当前知识库、白皮书和可核验来源；输入格式遵循 `PRODUCT_CATALOG_SCHEMA.md`。历史产品资料可作为候选来源，但必须标明核验状态和日期，不能自动成为文章事实。

## 路由

1. 先读取 `PRODUCT_CATALOG_SCHEMA.md` 与任务中指定产品的目录。
2. 再根据文章类型、内容对象、核心任务与证据决定角色。
3. 没有产品目录或可核验来源时，产品默认 `excluded`。

## formal_method
定位：正式解决方案
使用规则：允许进入文章 Methods / 正式解决方案部分。

## ultra_tip
定位：补充推荐
使用规则：只能作为补充方案、Ultra Tip、Alternative 等出现，
不能计入正式 Methods。

## ranked_candidate

定位：Top 或 Alternatives 中经过相同入选标准审查的候选项。

使用规则：必须与其他候选项公平比较；不能预设为第一名。

## comparison_subject

定位：VS 文章中被明确比较的对象。

使用规则：不是默认胜者；每个维度的结论必须由同一时间点的可比证据支持。

## implementation_tool

定位：泛主题或 What Is & Specs 中将已经解释的概念用于真实任务的工具。

使用规则：只能位于核心解释之后，不能替代定义、规格或主题答案。

## excluded
定位：禁止进入文章
使用规则：不得作为正式方法、推荐方案或产品露出。
