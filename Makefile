all:
	@echo "run 'make install/remove' with sudo to install/remove the file"

install:
	cp -p ./lgame.1 /usr/share/man/man1
	cp -p ./lgame /usr/bin/lgame
	chmod 755 /usr/bin/lgame
remove:
	rm -rf /usr/share/man/man1/lgame*
	rm -rf /usr/bin/lgame


