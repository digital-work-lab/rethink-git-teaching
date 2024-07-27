UID := $(shell id -u)
GID := $(shell id -g)
LANG := "en_CA.UTF-8"

LATEX_REF_DOC = --template /assets/basic.tex

PANDOC_CALL = docker run --rm \
	--volume "`pwd`:/data" \
	--volume "$(shell readlink -f ./assets)":/assets/ \
	--user $(shell id -u):$(shell id -g) \
	pandoc/ubuntu-latex

# Define a rule to build all slides
slides: lecture_slides

lecture_slides: slides.html slides.pptx slides.pdf

# Define a pattern rule for building a slide
slides.html: slides.md assets/theme.css
	docker run --rm --init -v "$(PWD)":/home/marp/app/ -e LANG=${LANG} -e MARP_USER="${UID}:${GID}" marpteam/marp-cli $< --theme-set assets/theme.css --html --allow-local-files -o $@

# Define a pattern rule for building pptx
slides.pptx: slides.md assets/theme.css
	docker run --rm --init -v "$(PWD)":/home/marp/app/ -e LANG=${LANG} -e MARP_USER="${UID}:${GID}" marpteam/marp-cli $< --theme-set assets/theme.css --pptx --allow-local-files -o $@

# Define a pattern rule for building pdf
output/slides.pdf: slides.md assets/theme.css
	docker run --rm --init -v "$(PWD)":/home/marp/app/ -e LANG=${LANG} -e MARP_USER="${UID}:${GID}" marpteam/marp-cli $< --theme-set assets/theme.css --pdf --allow-local-files -o $@
