.PHONY: deps install

ifndef NASHPATH
	$(error $$NASHPATH is not set)
endif

ifndef GOPATH
	$(error $$GOPATH is not set)
endif

all: deps install

deps:
	go get github.com/c0defellas/enzo/cmd/...

install:
	mkdir -p $(NASHPATH)/lib/nashcomplete
	cp all.sh $(NASHPATH)/lib/nashcomplete
	cp common.sh $(NASHPATH)/lib/nashcomplete
	cp deps.sh $(NASHPATH)/lib/nashcomplete
	cp files.sh $(NASHPATH)/lib/nashcomplete
	cp history.sh $(NASHPATH)/lib/nashcomplete
	cp kill.sh $(NASHPATH)/lib/nashcomplete
	cp programs.sh $(NASHPATH)/lib/nashcomplete
	cp systemd.sh $(NASHPATH)/lib/nashcomplete
