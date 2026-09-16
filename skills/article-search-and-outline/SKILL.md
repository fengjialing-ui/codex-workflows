---
name: article-search-and-outline
description: "Use only when explicitly asked to create a SERP content strategy brief and a decision-led article outline from a topic, a keyword table, and an optional recommended product."
metadata:
  short-description: "Build an article SERP brief and outline"
---

# Article Search and Outline

Create two separate upstream handoff documents:

1. **SERP Content Strategy Brief**: page-type evidence, intent, content gaps, differentiation and product-fit judgment.
2. **Article Outline**: a logically connected, reader-decision-led structure ready for the article workflow.

## Inputs and boundaries

Required: topic. Optional: keyword table and recommended product. Read market and language from the task or project configuration; do not assume them.

Treat a recommended product only as a task variable. Never create, rename or describe it as a Skill. Do not write article body copy, modify a page or run the downstream content workflow.

If the task also names external content or outline example libraries, do not use them in this Skill to choose a type or draft an outline. Record their availability for downstream `Reference Pattern Analyst` review only after current SERP research; examples are not templates or evidence.

## Research and outline

Research the current accessible SERP, classify organic results by primary page type and identify dominant or mixed intent. Choose the article type from evidence; do not assume every topic is How-to. Keep related but different intents as separate future-article opportunities.

Use the keyword table as an intent and coverage candidate list, not a hard-insertion list. Retain its source, date and status; flag irrelevant, duplicate, unnatural or unverified terms for review.

Organize the outline around the reader's decision path. For a How-to this may be `direct answer -> diagnose -> choose route -> execute -> verify -> limits -> prevention -> FAQ`; for another dominant intent derive an equivalent coherent path. Do not paste research findings, competitor notes, methods and product details into isolated chapters.

Recommend the supplied product only when evidence supports a task-level fit. Put it in the relevant method or decision path after context, state result checks and limitations, and omit it if unsupported. It must still be verified by this repository's Product Catalog and Type Module.

## Deliverables and handoff

In standalone use, save `<topic-slug>-serp-brief.md` and `<topic-slug>-outline.md` in the current task `outputs/` directory. When invoked as the upstream phase of this repository, save them under the active task's `research/` directory and then follow `standards/14-上游研究包接入与预研究Skills_v1.md`.

Include source links, research limitations and dates. The downstream workflow must use both documents as `prefill_only — verify_and_refresh`, not as final research, type routing, product approval or article copy.
