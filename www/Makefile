course = main

.PHONY : all clean test push

all: clean $(course)

test: clean
	raco test .

$(course):
	scribble --htmls \
		++style css/extra.css \
		++style css/fancyverb.css \
		++extra js/accessibility.js \
		++xref-in setup/xref load-collections-xref \
		--redirect-main http://docs.racket-lang.org/ \
		$(course).scrbl

push:
	rsync -avr --delete main/ junkfood.cs.umd.edu:/fs/www/class/winter2021/cmsc388Q/

clean:
	rm -rf $(course)
