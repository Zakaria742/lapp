all:
	@echo "run 'make install/remove' with sudo to install/remove the file"

install:
	cp -p ./mlapp /usr/share/man1
	cp -p ./lapp.sh /usr/bin/lapp
	chmod 755 /usr/bin/lapp
remove:
	rm -rf /usr/share/man1/mlapp
	rm -rf /usr/bin/lapp


