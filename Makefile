CC=coffee
CFLAGS=-c
LDFLAGS=
CPATH=script
SOURCES=$(CPATH)/support.coffee $(CPATH)/person.coffee $(CPATH)/map.coffee $(CPATH)/novel.coffee $(CPATH)/langengine.coffee $(CPATH)/visual-editor.coffee $(CPATH)/main.coffee

all: $(CPATH)/main.js
	
$(CPATH)/main.js: $(SOURCES)
	$(CC) -j $(CPATH)/main.js -c $(SOURCES)

clean:
	rm -f $(CPATH)/main.js

edit:
	pluma Makefile index.html style/style.css $(CPATH)/*.coffee &

ide: edit view
	$(CC) -j $(CPATH)/main.js -cw $(SOURCES)

view:
	iceweasel -new-tab index.html

gitup: clean
	git commit -a -m "`zenity --entry --text='Digite a mensagem de commit.' --title='kidcoder-csz@github'`"
	git push origin master
