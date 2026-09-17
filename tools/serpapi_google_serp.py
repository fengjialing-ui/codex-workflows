"""Fetch an auditable, current Google organic-result inventory through SerpApi.

This is a network fallback for environments without native live web search. It
does not replace required deep reads, page-type classification, or fact checks.
The API key is read only from SERPAPI_API_KEY and is never written to output.
"""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import sys
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode
from urllib.request import Request, urlopen

ENDPOINT = "https://serpapi.com/search.json"


def redact(value):
    if isinstance(value, dict):
        return {key: ("[redacted]" if key.casefold() in {"api_key", "key", "token"} else redact(item))
                for key, item in value.items()}
    if isinstance(value, list):
        return [redact(item) for item in value]
    return value


def fetch(query, location, country, language, limit, timeout, api_key, start=0):
    params = {
        "engine": "google", "q": query, "location": location, "gl": country,
        "hl": language, "num": limit, "start": start, "device": "desktop", "no_cache": "true",
        "api_key": api_key,
    }
    request = Request(f"{ENDPOINT}?{urlencode(params)}", headers={"User-Agent": "codex-workflows-serp-fallback/1.0"})
    with urlopen(request, timeout=timeout) as response:
        return json.loads(response.read().decode("utf-8"))


def markdown_report(payload, results, query, location, country, language):
    captured = datetime.now(timezone.utc).replace(microsecond=0).isoformat()
    metadata = payload.get("search_metadata", {})
    parameters = payload.get("search_parameters", {})
    rows = []
    seen = set()
    for result in results:
        title = str(result.get("title", "")).replace("|", "\\|")
        link = result.get("link", "")
        if title and link and link not in seen:
            seen.add(link)
            rows.append((title, link))
    lines = [
        "# SERP 与竞品分析（SerpApi 原始结果）", "",
        "> 此文件是实时 Google 自然结果清单，不是完整研究通过记录。必须继续完成 3–5 篇正文深读、页面类型人工复核、机会矩阵与事实核验。",
        "", f"- 查询：{query}", f"- 请求位置：{location}",
        f"- 实际位置：{parameters.get('location_used', location)}", f"- 市场参数：{country}",
        f"- 语言参数：{language}", f"- 抓取时间（UTC）：{captured}",
        f"- SerpApi 搜索 ID：{metadata.get('id', 'not returned')}",
        "- 来源：SerpApi Google Search API（`engine=google`，`no_cache=true`，desktop）", "",
        "| Natural rank | Title | URL | Page type |", "| --- | --- | --- | --- |",
    ]
    for position, (title, link) in enumerate(rows[:10], start=1):
        lines.append(f"| {position} | {title} | {link} | Unclassified — manual deep read required |")
    if len(rows) < 10:
        lines.extend(["", f"> 警告：仅返回 {len(rows)} 条有效自然结果；不可据此通过 Top 10 SERP 闸门。"])
    return "\n".join(lines) + "\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--query", required=True)
    parser.add_argument("--location", required=True, help="City/region/country used by SerpApi")
    parser.add_argument("--gl", required=True, help="Two-letter Google country code, e.g. us")
    parser.add_argument("--hl", required=True, help="Google UI language, e.g. en")
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--num", type=int, default=10)
    parser.add_argument("--timeout", type=int, default=45)
    args = parser.parse_args()
    if not 10 <= args.num <= 100:
        parser.error("--num must be between 10 and 100")
    api_key = os.environ.get("SERPAPI_API_KEY")
    if not api_key:
        print(json.dumps({"status": "blocked", "error": "SERPAPI_API_KEY is not set; do not place the key in a command, repository, or task artifact."}, ensure_ascii=False), file=sys.stderr)
        return 2
    try:
        payload = fetch(args.query, args.location, args.gl, args.hl, args.num, args.timeout, api_key)
        results = list(payload.get("organic_results", []))
        pages = {"page_1": payload}
        # Google can show fewer than ten organic cards on page one when rich-result
        # modules take space. Continue at offset 10 to complete the organic Top 10.
        if len(results) < 10:
            continuation = fetch(args.query, args.location, args.gl, args.hl, args.num, args.timeout, api_key, start=10)
            if continuation.get("error") or continuation.get("search_metadata", {}).get("status") == "Error":
                raise URLError(continuation.get("error", "SerpApi continuation search failed"))
            pages["page_2"] = continuation
            results.extend(continuation.get("organic_results", []))
    except HTTPError as exc:
        print(json.dumps({"status": "blocked", "error": f"SerpApi HTTP {exc.code}; check key, quota, and outbound access."}, ensure_ascii=False), file=sys.stderr)
        return 3
    except URLError as exc:
        print(json.dumps({"status": "blocked", "error": f"SerpApi network request failed: {exc.reason}"}, ensure_ascii=False), file=sys.stderr)
        return 4
    except (TimeoutError, json.JSONDecodeError) as exc:
        print(json.dumps({"status": "blocked", "error": f"SerpApi response could not be used: {exc}"}, ensure_ascii=False), file=sys.stderr)
        return 5
    if payload.get("error") or payload.get("search_metadata", {}).get("status") == "Error":
        print(json.dumps({"status": "blocked", "error": str(payload.get("error", "SerpApi returned a failed search"))}, ensure_ascii=False), file=sys.stderr)
        return 6
    args.output_dir.mkdir(parents=True, exist_ok=True)
    (args.output_dir / "serpapi-google-response.json").write_text(json.dumps(redact(pages), ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    (args.output_dir / "03_SERP与竞品分析.md").write_text(markdown_report(payload, results, args.query, args.location, args.gl, args.hl), encoding="utf-8")
    print(json.dumps({"status": "fetched", "organic_results": len({item.get("link") for item in results if item.get("link")}), "output_dir": str(args.output_dir)}, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
