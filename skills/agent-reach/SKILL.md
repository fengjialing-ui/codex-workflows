---
name: agent-reach
description: "Use only when explicitly asked to call Agent-Reach for external research. It gathers evidence from available channels and does not replace this repository's SEO or content workflow."
metadata:
  homepage: https://github.com/Panniantong/Agent-Reach
---

# Agent-Reach

Use this as an isolated external-research layer. It must not edit, rename, move, or replace any workflow or Skill in this repository.

Before platform research, run `agent-reach doctor --json` using the local executable configured by the environment. If it cannot finish, report that channel status is unverified. Do not install system dependencies, configure credentials, read cookies, or use a login-required channel unless the user explicitly requests that action.

Gather only evidence: source, date, platform, necessary short user wording, issue, scenario, and confidence. Use only channels shown usable by diagnostics or direct read-only checks. Do not draft article copy or invoke this repository's content workflow; return a structured evidence handoff instead.

When this Skill is used before the article workflow, follow `standards/14-上游研究包接入与预研究Skills_v1.md`: its evidence is supplemental and still requires current SERP, fact, product and type verification downstream.
