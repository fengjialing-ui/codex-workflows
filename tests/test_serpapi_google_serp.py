import json
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
import serpapi_google_serp as serp


class Response:
    def __init__(self, payload): self.payload = payload
    def read(self): return json.dumps(self.payload).encode("utf-8")
    def __enter__(self): return self
    def __exit__(self, *_): return False


class SerpApiTests(unittest.TestCase):
    def test_missing_key_blocks_without_network(self):
        with patch.dict(os.environ, {}, clear=True), patch("sys.argv", ["serp", "--query", "topic", "--location", "United States", "--gl", "us", "--hl", "en", "--output-dir", "ignored"]):
            self.assertEqual(serp.main(), 2)

    def test_fetch_writes_redacted_inventory(self):
        payload = {"search_metadata": {"status": "Success", "id": "abc"}, "search_parameters": {"location_used": "United States", "api_key": "secret"}, "organic_results": [{"position": n, "title": f"Result {n}", "link": f"https://example{n}.com"} for n in range(1, 11)]}
        with tempfile.TemporaryDirectory() as temp, patch.dict(os.environ, {"SERPAPI_API_KEY": "secret"}), patch.object(serp, "urlopen", return_value=Response(payload)), patch("sys.argv", ["serp", "--query", "topic", "--location", "United States", "--gl", "us", "--hl", "en", "--output-dir", temp]):
            self.assertEqual(serp.main(), 0)
            self.assertIn("| 10 | Result 10 |", (Path(temp) / "03_SERP与竞品分析.md").read_text(encoding="utf-8"))
            self.assertNotIn("secret", (Path(temp) / "serpapi-google-response.json").read_text(encoding="utf-8"))
