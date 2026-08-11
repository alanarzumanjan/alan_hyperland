import os
import glob
from PIL import Image

FOLDER = '.'
TARGET_FORMAT = 'png'
QUALITY = 100
IMAGE_EXTS = {'.jpg', '.jpeg', '.png', '.bmp', '.tiff', '.tif', '.webp'}

def is_image_file(filepath):
    ext = os.path.splitext(filepath)[1].lower()
    return ext in IMAGE_EXTS

def convert_and_rename(folder, target_format, quality=85):
    all_files = [f for f in os.listdir(folder) if os.path.isfile(os.path.join(folder, f))]
    image_files = [f for f in all_files if is_image_file(f)]
    if not image_files:
        print("Folder has no images.")
        return

    image_files.sort()  # alphabetical order, so '1.jpg' < '10.jpg' etc.

    target_ext = '.' + target_format
    if target_format == 'jpeg':
        target_ext = '.jpg'

    current_num = 1  # start numbering from 1

    for old_name in image_files:
        old_path = os.path.join(folder, old_name)
        base, ext = os.path.splitext(old_name)
        ext = ext.lower()

        # Check if this file already has the "correct" name
        # Correct means: base is a number equal to current_num AND extension equals target_ext
        if base.isdigit() and int(base) == current_num and ext == target_ext:
            print(f"Skip {old_name} (already correctly named)")
            current_num += 1
            continue

        new_name = f"{current_num}{target_ext}"
        new_path = os.path.join(folder, new_name)

        # If the new path already exists, we cannot overwrite it.
        # In normal flow this shouldn't happen if we skip correctly named files,
        # but we handle it gracefully.
        if os.path.exists(new_path):
            print(f"Warning: {new_path} already exists. Skipping {old_name} to avoid conflict.")
            current_num += 1
            continue

        try:
            with Image.open(old_path) as img:
                # Convert to RGB if target format does not support transparency
                if target_format in ('jpeg', 'jpg', 'webp'):
                    if img.mode in ('RGBA', 'LA', 'P'):
                        # Solid background color #1d1d2c (RGB: 29,29,44)
                        background = Image.new('RGB', img.size, (29, 29, 44))
                        background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                        img = background
                    elif img.mode != 'RGB':
                        img = img.convert('RGB')

                save_params = {}
                if target_format in ('jpeg', 'jpg', 'webp'):
                    save_params['quality'] = quality
                    if target_format == 'webp':
                        save_params['method'] = 6
                img.save(new_path, format=target_format.upper(), **save_params)

            os.remove(old_path)
            print(f"{old_name} -> {new_name} (converted to {target_format})")
            current_num += 1
        except Exception as e:
            print(f"Failed to convert {old_name}: {e}")
            # Do not increment current_num, so the next file gets the same number?
            # Actually we should increment to avoid infinite loop, but we can decide.
            # Usually better to increment to keep moving.
            current_num += 1

if __name__ == "__main__":
    convert_and_rename(FOLDER, TARGET_FORMAT, QUALITY)