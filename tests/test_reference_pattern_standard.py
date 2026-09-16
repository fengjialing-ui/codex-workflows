"""Regression checks for optional external-case-library integration."""
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]


class ReferencePatternStandardTests(unittest.TestCase):
    def test_standard_requires_research_before_reference_selection(self):
        text = (ROOT / 'standards' / '15-参考案例库接入与差异化生成_v1.md').read_text(encoding='utf-8')
        self.assertIn('Task Router 和当前 SERP/竞品研究完成后', text)
        self.assertIn('不得复制进 `standards/`、`examples/` 或最终交付包', text)
        self.assertIn('Reference Differentiation Audit', text)

    def test_router_and_skill_preserve_reference_boundaries(self):
        router = (ROOT / 'standards' / '08-多类型文章调度与共享标准_v1.md').read_text(encoding='utf-8')
        skills = (ROOT / 'standards' / '09-多类型内容生成Skills_v1.md').read_text(encoding='utf-8')
        self.assertIn('案例不得决定最终类型、标题树、Methods 数量/顺序、产品角色/CTA', router)
        self.assertIn('Reference Pattern Analyst', skills)
        self.assertIn('不提取可复用文案', skills)


if __name__ == '__main__':
    unittest.main()
