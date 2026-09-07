"""Portable final gate for all supported article types; never runs arbitrary package code."""
import argparse
import json
import re
from pathlib import Path
from delivery_integrity import (local_file, read_json, check_render, check_docx_parity,
    docx_content, image_info, digest, markdown_text, text_tokens, check_contract)
from workflow_state import validate as validate_state

ROOT=Path(__file__).resolve().parents[1]
REQUIRED_FILES=[
 '00_最终交付包索引.md','01_节点产出与状态总表.md','02_关键词与搜索意图分析.md',
 '03_SERP与竞品分析.md','04_Content_Brief.md','05_文章结构与关键词映射.md',
 '06_完整文章.md','06_完整文章.docx','07_视觉资产与映射表.md','08_SEO发布信息.md',
 '09_事实与来源核验表.md','10_完整流程执行报告.md','11_标准回审与质量报告.md',
 '12_版本与修改记录.md','13_内容资产保留审计.md','14_终稿交付清单.md',
 'qa-render.json','workflow-state.json','release-manifest.json','editorial-qa.json']
ARTICLE_TYPES={'how_to','top_evaluation','vs','general_topic','alternatives','what_is_specs'}
PRODUCT_ROLES={
 'how_to':{'formal_method','ultra_tip','excluded'},
 'top_evaluation':{'ranked_candidate','excluded'},
 'vs':{'comparison_subject','excluded'},
 'general_topic':{'implementation_tool','ultra_tip','excluded'},
 'alternatives':{'ranked_candidate','excluded'},
 'what_is_specs':{'implementation_tool','ultra_tip','excluded'}}

def narrative_count(markdown,source_heading='Sources'):
    lines=[];in_sources=False
    for line in markdown.splitlines():
        if re.match(r'^##\s+'+re.escape(source_heading)+r'\s*$',line,re.I): in_sources=True
        if in_sources or line.strip().startswith(('|','![')): continue
        if re.match(r'^\s*(?:\*\*)?(?:SEO title|Meta description|Slug|URL slug|Primary keyword|Secondary keywords):',line,re.I):continue
        lines.append(line)
    return len(text_tokens(markdown_text('\n'.join(lines))))

def validate(package):
    errors=[]; package=Path(package).resolve()
    try:
        for name in REQUIRED_FILES: local_file(package,name)
        cfg=read_json(package/'release-manifest.json'); config=read_json(ROOT/'workflow.json')
        if cfg.get('workflow_version')!=config['version']: errors.append('Release workflow version mismatch')
        state=read_json(package/'workflow-state.json')
        errors += validate_state(state,config,ROOT,package)
        errors += check_contract(cfg,package,config['contract_fields'])
        if cfg.get('run_id')!=state.get('run_id'): errors.append('Release and workflow run IDs differ')
        if cfg.get('article_type') not in ARTICLE_TYPES: errors.append('Unsupported article_type')
        if cfg.get('mode') not in {'new_article','optimization','rewrite'}: errors.append('Missing valid task mode')
        if cfg.get('mode')=='rewrite' and not cfg.get('rewrite_authorization'): errors.append('Rewrite lacks user authorization reference')
        markdown=(package/'06_完整文章.md').read_text(encoding='utf-8')
        docx=package/'06_完整文章.docx'; data=docx_content(docx)
        errors += check_docx_parity(markdown,docx)
        metadata=cfg.get('seo_metadata',{})
        for field in ['title','meta_description','slug']:
            value=metadata.get(field)
            if not isinstance(value,str) or not value.strip() or value not in data['text']:
                errors.append('SEO metadata missing from final Word: '+field)
        primary=cfg.get('primary_keyword','').strip()
        if not primary: errors.append('Missing primary keyword')
        heading=next((text for level,text in data['headings'] if level==1),'')
        if primary and primary.casefold() not in heading.casefold():
            alternative=cfg.get('primary_keyword_alternative',{})
            if not alternative.get('reason') or alternative.get('heading')!=heading:
                errors.append('Primary intent needs an exact H1 placement or documented natural heading alternative')
        qa_heading=cfg.get('quick_answer_heading')
        if qa_heading:
            if qa_heading not in [h for _,h in data['headings']]: errors.append('Declared answer heading is absent')
        elif cfg.get('article_type')=='how_to' and not cfg.get('answer_location'):
            errors.append('How-to requires a mapped immediate answer, not a fixed English title')
        word_count=narrative_count(markdown,cfg.get('source_section_heading','Sources'))
        if cfg.get('validated_narrative_word_count') != word_count: errors.append('Recorded narrative word count differs from actual article')
        bounds=cfg.get('validated_word_range',[])
        if len(bounds)!=2 or not all(isinstance(x,int) and x>0 for x in bounds) or bounds[0]>bounds[1]:
            errors.append('Validated positive word range missing')
        elif not bounds[0]<=word_count<=bounds[1] and not cfg.get('word_range_exception'):
            errors.append(f'Article word count {word_count} falls outside research-backed range {bounds}')
        # A true natural-rank inventory must have each rank once for the designated core query.
        serp=(package/'03_SERP与竞品分析.md').read_text(encoding='utf-8')
        for field in ['Natural rank','Title','URL','Page type']:
            if field not in serp: errors.append('SERP schema missing '+field)
        rows=re.findall(r'^\|\s*(10|[1-9])\s*\|([^\n]*)',serp,re.M)
        if sorted(int(rank) for rank,_ in rows)!=list(range(1,11)): errors.append('SERP must contain unique organic ranks 1–10 for the designated core query')
        for rank,row in rows:
            if not re.search(r'https?://[^\s|]+',row): errors.append('SERP URL missing at rank '+rank)
        if not cfg.get('serp_query') or not cfg.get('serp_market') or not cfg.get('serp_capture_date'): errors.append('SERP query/market/capture date missing')
        product=cfg.get('product',{})
        if product.get('recommended') not in {'none',None,''}:
            if product.get('role') not in PRODUCT_ROLES.get(cfg.get('article_type'),set()): errors.append('Product role is not valid for this article type')
            if product.get('role')=='excluded' and (product.get('resolution')!='user_confirmed' or not product.get('authorization_reference')):
                errors.append('Recommended product excluded without user confirmation')
            if product.get('role')!='excluded':
                if not str(product.get('official_source','')).startswith('https://') or not product.get('verified_date'):
                    errors.append('Recommended product needs current official evidence')
                if product.get('official_source') not in data['links']: errors.append('Official product evidence is missing from final Word links')
        elif product.get('recommended')!='none': errors.append('Explicitly record recommended product or none')
        keyword_map=(package/'05_文章结构与关键词映射.md').read_text()
        if primary and primary.casefold() not in keyword_map.casefold(): errors.append('Primary keyword missing from keyword map')
        visibility=cfg.get('keyword_visibility')
        if visibility=='yellow_highlight':
            terms=cfg.get('keyword_highlight_terms',[])
            if not terms or any(term.casefold() not in data['yellow_text'].casefold() for term in terms):
                errors.append('Requested yellow keyword placements are missing from final Word')
        elif visibility=='report_only': local_file(package,cfg.get('keyword_report'))
        elif visibility!='not_requested': errors.append('Declare keyword_visibility: not_requested, report_only or yellow_highlight')
        preservation=(package/'13_内容资产保留审计.md').read_text()
        if 'Review mode: '+str(cfg.get('mode')) not in preservation: errors.append('Mode differs from preservation audit')
        if cfg.get('mode')=='optimization':
            source=local_file(package,cfg.get('source_docx'))
            source_words=len(text_tokens(docx_content(source)['text']))
            if word_count < source_words*.70 and not cfg.get('reduction_authorization'): errors.append('Unapproved source compression above 30%')
            retention=cfg.get('effective_information_retention_pct')
            if not isinstance(retention,(float,int)) or not 0<=retention<=100: errors.append('Effective-information retention audit missing')
            elif retention<80 and not cfg.get('reduction_authorization'): errors.append('Information retention below 80% without authorization')
        visuals=cfg.get('visuals',[]); sections=cfg.get('required_visual_sections')
        if not isinstance(sections,list): raise ValueError('Declare required_visual_sections for this article type')
        if not sections and not cfg.get('no_visuals_scope_reason'): errors.append('No-visual scope needs an explicit task reason')
        actual_headings={text for _,text in data['headings']}
        for section in sections:
            if section not in actual_headings: errors.append('Visual section absent: '+section)
            if not any(v.get('section')==section for v in visuals): errors.append('Section has no mapped visual: '+section)
        for visual in visuals:
            path=local_file(package,visual.get('path')); image_info(path)
            if digest(path) not in data['media']: errors.append('Independent visual is not embedded: '+str(visual.get('path')))
            if not visual.get('alt') or not visual.get('caption') or not visual.get('purpose'): errors.append('Visual mapping lacks Alt/caption/purpose')
            if visual.get('caption') not in data['text']: errors.append('Visual caption absent from Word')
            if not any(n.get('descr')==visual.get('alt') for n in data['images']): errors.append('Mapped Alt differs from embedded image Alt')
        errors += check_render(read_json(package/'qa-render.json'),package,docx)
        qa=read_json(package/'editorial-qa.json')
        if qa.get('result')!='pass' or qa.get('reviewer_type') not in {'ai','human'} or not qa.get('reviewed_by'):
            errors.append('Editorial QA status/reviewer missing')
        required_qa={'intent','structure','keyword_naturalness','product_truth','sources','visual_quality','document_quality'}
        if cfg.get('mode')=='optimization': required_qa.add('source_preservation')
        for field in required_qa:
            item=qa.get('checks',{}).get(field,{})
            if item.get('result')!='pass' or not item.get('finding'): errors.append('Editorial QA unresolved: '+field)
            local_file(package,item.get('evidence'))
        if cfg.get('human_approval_required') is True:
            approval=qa.get('human_approval',{})
            if approval.get('reviewer_type')!='human' or approval.get('result')!='pass' or not approval.get('reviewed_by') or not approval.get('reference'):
                errors.append('Required real human approval is missing')
        elif cfg.get('human_approval_required') is not False: errors.append('Declare human_approval_required explicitly')
        expected=cfg.get('expected_files',[])
        if not expected or len(expected)!=len(set(expected)): errors.append('Empty or duplicated package inventory')
        actual={p.relative_to(package).as_posix() for p in package.rglob('*') if p.is_file()}
        if actual!=set(expected): errors.append('Package file inventory differs from manifest')
    except (KeyError,ValueError,TypeError,OSError) as exc: errors.append(str(exc))
    return {'status':'BLOCKED — Not Publish Ready' if errors else 'PASS — Publish Ready','publication_ready':not errors,'errors':errors}

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--package',type=Path,required=True);args=p.parse_args()
    try: result=validate(args.package)
    except Exception as exc: result={'status':'BLOCKED — Not Publish Ready','publication_ready':False,'errors':[str(exc)]}
    print(json.dumps(result,ensure_ascii=False,indent=2));return 0 if result['publication_ready'] else 1

if __name__=='__main__':raise SystemExit(main())
