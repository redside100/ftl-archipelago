import shutil
from pathlib import Path
import tempfile


def package_mod():

    tempdir = Path(tempfile.mkdtemp())

    # Copy original mod files
    shutil.copytree("mod", tempdir.as_posix(), dirs_exist_ok=True)

    # Copy generated append files
    for generated_file_path in Path("dist/data/").glob("*.xml.append"):
        dest_path = tempdir / "data" / generated_file_path.name
        if not dest_path.exists():
            shutil.copy(generated_file_path.as_posix(), dest_path.as_posix())
            continue

        # If it exists, prepend
        old_content = dest_path.read_text()
        append_content = generated_file_path.read_text()
        new_content = f"{append_content}\n\n<!-- Start {generated_file_path.name} -->\n\n{old_content}"
        dest_path.write_text(new_content)

    # Package
    shutil.make_archive("ftl-ap", "zip", tempdir)
    original_zip = Path("ftl-ap.zip")
    target_ftl = Path("dist/FTL Archipelago.ftl")
    target_ftl.parent.mkdir(exist_ok=True)
    shutil.move(original_zip.as_posix(), target_ftl.as_posix())

    shutil.rmtree(tempdir)


if __name__ == "__main__":
    package_mod()
