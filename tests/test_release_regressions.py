import json
from pathlib import Path
import tempfile
import unittest
from test_execution import ROOT, docx, png, complete_stages, save
from delivery_integrity import digest
from validate_article_package import validate, REQUIRED_FILES, narrative_count

def package_fixture(run,article_type='vs'):
    for name in REQUIRED_FILES:
        if name not in {'workflow-state.json','release-manifest.json'}: (run/name).write_text('Synthetic fixture evidence, not a production article.')
    markdown='SEO title: Topic guide\n\nMeta description: Understand this topic clearly.\n\nSlug: topic-guide\n\n# Topic\n\nComplete article text.\n\n## Decision\n\nChoose a suitable option.'
    (run/'06_完整文章.md').write_text(markdown)
    docx(run/'06_完整文章.docx',[(0,'SEO title: Topic guide'),(0,'Meta description: Understand this topic clearly.'),(0,'Slug: topic-guide'),(1,'Topic'),(0,'Complete article text.'),(2,'Decision'),(0,'Choose a suitable option.')])
    (run/'05_文章结构与关键词映射.md').write_text('| Keyword | Location | Status |\n| Topic | H1 | Covered |')
    (run/'13_内容资产保留审计.md').write_text('Review mode: new_article')
    (run/'03_SERP与竞品分析.md').write_text('| Natural rank | Title | URL | Page type |\n|---|---|---|---|\n'+'\n'.join(f'| {i} | Result {i} | https://example{i}.com | Article |' for i in range(1,11)))
    png(run/'render-page.png')
    save(run/'qa-render.json',{'status':'pass','source_docx_sha256':digest(run/'06_完整文章.docx'),'reviewer_type':'ai','reviewed_by':'Regression fixture','inspection':'Synthetic image fixture','page_count':1,'page_files':[{'path':'render-page.png','sha256':digest(run/'render-page.png')}]})
    qa={'result':'pass','reviewer_type':'ai','reviewed_by':'Regression fixture','checks':{name:{'result':'pass','finding':'Synthetic fixture assertion','evidence':'06_完整文章.md'} for name in ['intent','structure','keyword_naturalness','product_truth','sources','visual_quality','document_quality']}}
    save(run/'editorial-qa.json',qa)
    save(run/'task-contract.json',{'human_approval_required':False,'mode':'new_article','article_type':article_type,'required_visual_sections':[],'keyword_visibility':'not_requested'})
    complete_stages(run,'06_完整文章.md')
    cfg={'workflow_version':'3.1.0','run_id':'TEST','article_type':article_type,'mode':'new_article','primary_keyword':'Topic','validated_word_range':[1,100],'serp_query':'Topic','serp_market':'US','serp_capture_date':'2026-09-07','product':{'recommended':'none'},'required_visual_sections':[],'no_visuals_scope_reason':'Explicit synthetic fixture scope without visuals','human_approval_required':False}
    if article_type=='how_to': cfg['answer_location']='Opening paragraph'
    cfg['validated_narrative_word_count']=narrative_count(markdown)
    cfg['seo_metadata']={'title':'Topic guide','meta_description':'Understand this topic clearly.','slug':'topic-guide'}
    cfg['keyword_visibility']='not_requested'
    cfg['expected_files']=sorted([p.relative_to(run).as_posix() for p in run.rglob('*') if p.is_file()]+['release-manifest.json'])
    save(run/'release-manifest.json',cfg)

class ReleaseTests(unittest.TestCase):
    def setUp(self):self.tmp=tempfile.TemporaryDirectory();self.run=Path(self.tmp.name);package_fixture(self.run)
    def tearDown(self):self.tmp.cleanup()
    def test_valid_vs_without_howto_heading(self):self.assertTrue(validate(self.run)['publication_ready'],validate(self.run))
    def test_missing_file_blocks(self):
        (self.run/'09_事实与来源核验表.md').unlink();self.assertFalse(validate(self.run)['publication_ready'])
    def test_missing_body_blocks(self):
        docx(self.run/'06_完整文章.docx',[(1,'Topic'),(2,'Decision'),(0,'Choose a suitable option.')]);self.assertFalse(validate(self.run)['publication_ready'])
    def test_duplicate_ranks_block(self):
        p=self.run/'03_SERP与竞品分析.md';p.write_text(p.read_text().replace('| 10 |','| 1 |'));self.assertFalse(validate(self.run)['publication_ready'])
    def test_required_human_cannot_be_ai(self):
        p=self.run/'release-manifest.json';cfg=json.loads(p.read_text());cfg['human_approval_required']=True;save(p,cfg);self.assertFalse(validate(self.run)['publication_ready'])
    def test_stale_render_blocks(self):
        p=self.run/'qa-render.json';cfg=json.loads(p.read_text());cfg['source_docx_sha256']='0'*64;save(p,cfg);self.assertFalse(validate(self.run)['publication_ready'])
    def test_all_article_types_use_their_contract(self):
        for kind in ['how_to','top_evaluation','vs','general_topic','alternatives','what_is_specs']:
            with tempfile.TemporaryDirectory() as tmp:
                run=Path(tmp);package_fixture(run,kind);self.assertTrue(validate(run)['publication_ready'],validate(run))

if __name__=='__main__':unittest.main()
