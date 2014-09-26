all: fetch modules

fetch:
	git pull

upload:
	git push

modules: Puppetfile
	librarian-puppet install
	librarian-puppet update

.PHONY: modules
