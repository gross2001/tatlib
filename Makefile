

startProject:
	docker compose run --rm hugo new site /src --force


start:
	docker compose up

generateHTML:
	docker compose run --rm hugo --destination /src/public






HUGO_VERSION = 0.150.1
HUGO_URL = https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_extended_$(HUGO_VERSION)_linux-amd64.tar.gz
HUGO_BIN = ./bin/hugo
SITE_DIR = ./site
PUBLIC_DIR = ../public
SITE_DIR = ./site
BOOKS_CONTENT = $(SITE_DIR)/content/books

# Установка Hugo локально
$(HUGO_BIN):
	mkdir -p bin
	curl -L $(HUGO_URL) | tar -xz -C bin hugo


# Инициализация нового проекта Hugo
init: $(HUGO_BIN)
	test -d $(SITE_DIR) || ( \
		$(HUGO_BIN) new site $(SITE_DIR); \
		rm -rf $(SITE_DIR)/public; \
	)
	@echo "✅ Hugo site создан в $(SITE_DIR)/"


# Запуск сервера для разработки
serve: $(HUGO_BIN)
	$(HUGO_BIN) server -s $(SITE_DIR) -D

# Сборка сайта
build: $(HUGO_BIN)
	$(HUGO_BIN) -s $(SITE_DIR) --destination $(PUBLIC_DIR)

# Обновление Hugo вручную
update: clean $(HUGO_BIN)




generate-books:
	python3 scripts/generate_books.py


# Очистка сгенерированных файлов
clean:
	rm -rf ./public $(BOOKS_CONTENT)/*
