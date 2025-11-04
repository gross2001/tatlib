SITE_DIR = ./site
PUBLIC_DIR = ./site/public
BOOKS_CONTENT = $(SITE_DIR)/content/books

OS = linux-amd64 # доступные OS можно посмотреть здесь https://github.com/gohugoio/hugo/releases
HUGO_VERSION = 0.150.1
HUGO_URL = https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_extended_$(HUGO_VERSION)_$(OS).tar.gz
HUGO_BIN = ./bin/hugo

PAGEFIND_BIN = ./bin/pagefind
PAGEFIND_VERSION = 1.4.0
PAGEFIND_URL = https://github.com/pagefind/pagefind/releases/download/v$(PAGEFIND_VERSION)/pagefind-v1.4.0-x86_64-unknown-linux-musl.tar.gz


# Для создания md-файлов
generate-books:
	python3 scripts/generate_books.py

# Установка Hugo локально (скачивается бинарник в папку bin)
$(HUGO_BIN):
	mkdir -p bin
	curl -L $(HUGO_URL) | tar -xz -C bin hugo

# Установка Pagefind локально
$(PAGEFIND_BIN):
	mkdir -p bin
	curl -L $(PAGEFIND_URL) | tar -xz -C bin pagefind
	chmod +x $(PAGEFIND_BIN)

# Запуск сервера для разработки
serve: submodules $(HUGO_BIN)
	$(HUGO_BIN) server -s $(SITE_DIR) -D -O

# Запуск pagefind для корректного работы поиска
pagefind: $(PAGEFIND_BIN)
	$(PAGEFIND_BIN) --site "$(PUBLIC_DIR)"

# Очистка сгенерированных файлов
clean:
	rm -rf ./public $(BOOKS_CONTENT)/*

# Инициализация git submodules (нужно для подключаемой темы оформления)
submodules:
	git submodule update --init --recursive

# Инициализация нового проекта Hugo (не нужно больше использовать)
init: $(HUGO_BIN)
	test -d $(SITE_DIR) || ( \
		$(HUGO_BIN) new site $(SITE_DIR); \
		rm -rf $(SITE_DIR)/public; \
	)
	@echo "✅ Hugo site создан в $(SITE_DIR)/"
