import shutil
from pathlib import Path

def package_mod():
    shutil.make_archive('ftl-ap', 'zip', 'mod')
    original_zip = Path('ftl-ap.zip')
    target_ftl = Path('dist/FTL Archipelago.ftl')
    target_ftl.parent.mkdir(exist_ok=True)
    shutil.move(original_zip.as_posix(), target_ftl.as_posix())

if __name__ == '__main__':
    package_mod()