DISTRIB = archlinux
ELIXIR_BRANCH = 1.0.x
DIRECTORY = $(DISTRIB)-$(ELIXIR_BRANCH)
NAME = jonathantron/armhf-$(DISTRIB)-elixir
VERSION = 1.0.3

HOST_NOT_ARM = $(if [[ uname -a | grep -q x86_64 ]]; then "1"; if)

.PHONY: all build test tag_latest release

all: build

ifeq (HOST_NOT_ARM,"1")
build:
	@if ! test -f /proc/sys/fs/binfmt_misc/arm; then sudo sh -c 'echo ":arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-arm-static:" > /proc/sys/fs/binfmt_misc/register'; fi
	@cp /usr/bin/qemu-arm-static $(DIRECTORY)/
	time docker build  -f $(DIRECTORY)/Dockerfile.x86_64 -t $(NAME):$(VERSION) --rm $(DIRECTORY)
else
build:
	time docker build -t $(NAME):$(VERSION) --rm $(DIRECTORY)
endif

test:
	# Need to be on the same host as docker daemon, because we mount shared test
	# directory...
	env NAME=$(NAME) VERSION=$(VERSION) ./test/runner.sh

tag_latest:
	cd $(DIRECTORY)
	docker tag -f $(NAME):$(VERSION) $(NAME):latest

release: test tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! head -n 1 Changelog.md | grep -q 'release date'; then echo 'Please note the release date in Changelog.md.' && false; fi
	docker push $(NAME)
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"
