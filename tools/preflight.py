"""Cross-platform capability check; final actual render evidence is still mandatory."""
import argparse
import json
from pathlib import Path
import shutil

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--renderer',help='Available renderer executable or path; default searches LibreOffice')
    args=p.parse_args(); errors=[]
    root=Path(__file__).resolve().parent
    for name in ['validate_article_package.py','delivery_integrity.py','workflow_state.py']:
        if not (root/name).is_file(): errors.append('Missing workflow component: '+name)
    renderer=shutil.which(args.renderer) if args.renderer else (shutil.which('soffice') or shutil.which('libreoffice'))
    if not renderer and not args.renderer:
        for value in ['C:/Program Files/LibreOffice/program/soffice.exe','/Applications/LibreOffice.app/Contents/MacOS/soffice']:
            if Path(value).is_file(): renderer=value;break
    if not renderer: errors.append('No renderer discovered. Configure --renderer for another renderer; actual DOCX/page hashes and visual QA remain required.')
    print(json.dumps({'status':'blocked' if errors else 'capability_probe_pass','renderer':renderer,'errors':errors,'scope':'Executable discovery only; test image generation and final DOCX rendering during the task.'},ensure_ascii=False,indent=2))
    return 1 if errors else 0

if __name__=='__main__':raise SystemExit(main())
