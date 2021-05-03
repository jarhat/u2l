.PHONY: install usb weaponize disarm clean


install: weaponize
	./install.sh

weaponize:
	chmod +x *.sh
	chmod +x sets/*/*.sh

disarm:
	chmod -x *.sh
	chmod -x sets/*/*.sh

clean:
	rm sets/*/stages/*

