import csv
import re
import yaml
from pathlib import Path

# Пути
BASE_DIR = Path(__file__).resolve().parent.parent
CSV_PATH = BASE_DIR / "data" / "monocorpus - monocorpus.csv"
OUTPUT_DIR = BASE_DIR / "site" / "content" / "books"

# Создаём папку, если её нет
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# Ограничение на кол-во записей
LIMIT = 10

with CSV_PATH.open(encoding="utf-8") as f:
    reader = csv.DictReader(f)

    for i, row in enumerate(reader):
        #if i >= LIMIT:
        #    break
         # фильтрация: пропускаем если sharing_restricted=1 или full=0
        if row.get("sharing_restricted") == "1":
            continue
        if row.get("full") == "0":
            continue

        title = row.get("title", "").strip()
        if not title:
                title = f"Untitled {i}"
        slug = title.replace(" ", "_")
        slug_safe = re.sub(r'[\\/:"*?<>|]', "_", slug)
        slug_safe = slug_safe.replace(" ", "_")
        slug_safe = slug_safe[:30]
        md_path = OUTPUT_DIR / f"{slug_safe}.md"

         # Разбиваем жанры по запятой
        genres_raw = row.get("genre", "")
        genres = [g.strip() for g in genres_raw.split(",") if g.strip()]

        # Формируем front matter
        front_matter_dict = {
            "title": title,
            "authors": row.get("author", "").strip()[:50],
            "publisher": row.get("publisher", "").strip()[:50],
            "isbn": row.get("isbn", "").strip(),
            "publish_date": row.get("publish_date", "").strip(),
            "genres": genres, 
            "page_count": row.get("page_count", "").strip(),
            "download_link": row.get("ya_public_url", "").strip(),
            "json_ld": row.get("metadata_json", "").strip(),
            "draft": False,
        }
        front_matter = "---\n" + yaml.safe_dump(front_matter_dict, allow_unicode=True) + "---\n"

        # Пишем файл
        md_path.write_text(front_matter, encoding="utf-8")

print(f"✅ Сгенерировано {i} файлов в {OUTPUT_DIR}")
