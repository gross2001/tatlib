OS = linux-amd64 # доступные OS можно посмотреть здесь https://github.com/gohugoio/hugo/releases
HUGO_VERSION = 0.150.1
HUGO_URL = https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_extended_$(HUGO_VERSION)_$(OS).tar.gz
HUGO_BIN = ./bin/hugo
SITE_DIR = ./site
PUBLIC_DIR = ./site/public
BOOKS_CONTENT = $(SITE_DIR)/content/books

# Для создания md-файлов
generate-books:
	python3 scripts/generate_books.py

# Установка Hugo локально (скачивается бинарник в папку bin)
$(HUGO_BIN):
	mkdir -p bin
	curl -L $(HUGO_URL) | tar -xz -C bin hugo

# Инициализация нового проекта Hugo (не нужно больше использовать)
init: $(HUGO_BIN)
	test -d $(SITE_DIR) || ( \
		$(HUGO_BIN) new site $(SITE_DIR); \
		rm -rf $(SITE_DIR)/public; \
	)
	@echo "✅ Hugo site создан в $(SITE_DIR)/"

# Запуск сервера для разработки
serve: $(HUGO_BIN)
	$(HUGO_BIN) server -s $(SITE_DIR) -D -O

# Очистка сгенерированных файлов
clean:
	rm -rf ./public $(BOOKS_CONTENT)/*