DATE = $(shell date +%I:%M%p)
CHECK = \033[32m✔\033[39m
HR = ---------------------------------------------------


# Build Docs #

build:
	@echo "\n${HR}"
	@echo "Cooking furatto..."
	@echo "${HR}\n"
	@compass compile -c production_config.rb --force
	@echo "Spicing things with Compass...               ${CHECK}"
	@cat js/snap.js js/panel.js js/jquery.toolbar.js js/toolbar.js js/rainbow-custom.min.js js/tooltip.js js/picker.js js/picker.date.js js/legacy.js js/responsive-tables.js js/dropdown.js js/modal.js js/idangerous.swiper-2.1.js js/nav.js js/manifest.js > js/furatto.js
	@./node_modules/.bin/uglifyjs -nc js/furatto.js > documentation/assets/js/furatto.min.tmp.js
	@cat documentation/assets/js/furatto.min.tmp.js > documentation/assets/js/furatto.min.js
	@rm documentation/assets/js/furatto.min.tmp.js
	@cp js/furatto.js documentation/assets/js
	@cp js/jquery.js documentation/assets/js
	@cp js/furatto-demo.js documentation/assets/js
	@echo "Compiling and minifiying JS...               ${CHECK}"
	@cp -r fonts documentation/assets/
	@cp -r img documentation/assets/
	@echo "Copying fonts and images to assets...        ${CHECK}"
	@echo "\n${HR}"
	@echo "Furatto was successfully built at ${DATE}"
	@echo "${HR}\n"
	@echo "Thanks for using Furatto."
	@echo "Lov @kurenn and @icalialabs\n"

# Build Furatto directory #
furatto: furatto-img furatto-js furatto-css furatto-font furatto-examples furatto-sass

# JS #
furatto-js: furatto/js/*.js

furatto/js/*.js: js/*.js
	mkdir -p furatto/js
	cp documentation/assets/js/*js furatto/js/

# CSS #
furatto-css: furatto/css/*.css

furatto/css/*.css:
	mkdir -p furatto/css
	cp documentation/assets/css/*.css furatto/css

# SASS #
furatto-sass:
	cp -r scss furatto

# IMAGES #
furatto-img: furatto/img/*

furatto/img/*: img/*
	mkdir -p furatto/img
	cp -r img/* furatto/img/

# FONTS #
furatto-font: furatto/fonts/*

furatto/fonts/*: fonts/*
	mkdir -p furatto/fonts
	cp -r fonts/* furatto/fonts/

# EXAMPLES #
furatto-examples: 
	cp -r documentation/examples furatto

# Make for gh-pages, intended just for @kurenn #

gh-pages: furatto
	rm -f documentation/assets/furatto.zip
	zip -r documentation/assets/furatto.zip furatto
	rm -r furatto
	rm -r ../furatto-gh-pages/assets/furatto.zip
	node documentation/build production
	cp -r documentation/* ../furatto-gh-pages
