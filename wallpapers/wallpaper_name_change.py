import os
import shutil
from PIL import Image

FOLDER = '.'
TARGET_FORMAT = 'png'
QUALITY = 100
IMAGE_EXTS = {'.jpg', '.jpeg', '.png', '.bmp', '.tiff', '.tif', '.webp'}

def is_image(f):
    return os.path.splitext(f)[1].lower() in IMAGE_EXTS

def main():
    files = [f for f in os.listdir(FOLDER) if os.path.isfile(os.path.join(FOLDER, f)) and is_image(f)]
    if not files:
        print("No images.")
        return
    files.sort()
    temp = os.path.join(FOLDER, '.temp_rename')
    if os.path.exists(temp):
        shutil.rmtree(temp)
    os.makedirs(temp)
    for f in files:
        shutil.move(os.path.join(FOLDER, f), os.path.join(temp, f))
    temp_files = [f for f in os.listdir(temp) if is_image(f)]
    temp_files.sort()
    ext = '.' + TARGET_FORMAT
    if TARGET_FORMAT == 'jpeg':
        ext = '.jpg'
    for i, old in enumerate(temp_files, start=1):
        old_path = os.path.join(temp, old)
        new_path = os.path.join(FOLDER, f"{i}{ext}")
        with Image.open(old_path) as img:
            if TARGET_FORMAT in ('jpeg', 'jpg', 'webp'):
                if img.mode in ('RGBA', 'LA', 'P'):
                    bg = Image.new('RGB', img.size, (29, 29, 44))
                    bg.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                    img = bg
                elif img.mode != 'RGB':
                    img = img.convert('RGB')
            save_params = {}
            if TARGET_FORMAT in ('jpeg', 'jpg', 'webp'):
                save_params['quality'] = QUALITY
                if TARGET_FORMAT == 'webp':
                    save_params['method'] = 6
            img.save(new_path, format=TARGET_FORMAT.upper(), **save_params)
        os.remove(old_path)
        print(f"{old} -> {i}{ext}")
    os.rmdir(temp)

if __name__ == "__main__":
    main()