DISTRIB = archlinux
ELIXIR_BRANCH = 1.0.x
HOST_ARCH = $(shell uname -m)
DIRECTORY = $(HOST_ARCH)-$(DISTRIB)-$(ELIXIR_BRANCH)
NAME = jonathantron/$(HOST_ARCH)-$(DISTRIB)-elixir
VERSION = 1.0.3

override HOST_NOT_ARM = $(shell uname -m | grep -q x86_64 && echo 1)

.PHONY: all build test tag_latest release clean

all: build

clean:
	rm -f arm*/*.sh arm*/qemu-*

copy_commons:
	@cp $(DISTRIB)-commons/* $(DIRECTORY)/

build_qemu_wrapper:
	@if test "$(HOST_ARCH)" != "armv7l" -a "$(HOST_ARCH)" != "armv6l"; then echo "You need to set HOST_ARCH to the targeted arm version (supported: armv7l, armv6l given: '$(HOST_ARCH)')" && false; fi
	gcc -static tools/qemu-$(HOST_ARCH)-static-wrap.c -O3 -s -o tools/qemu-$(HOST_ARCH)-static-wrap
	@chmod +x tools/qemu-$(HOST_ARCH)-static-wrap

ifeq ($(HOST_NOT_ARM),1)
build: build_qemu_wrapper copy_commons
	@if test "$(HOST_ARCH)" != "armv7l" -a "$(HOST_ARCH)" != "armv6l"; then echo "You need to set HOST_ARCH to the targeted arm version (supported: armv7l, armv6l given: '$(HOST_ARCH)')" && false; fi
	@if ! test -f /proc/sys/fs/binfmt_misc/arm; then sudo sh -c 'echo ":arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-arm-static-wrap:" > /proc/sys/fs/binfmt_misc/register'; fi
	@cp /usr/bin/qemu-arm-static $(DIRECTORY)/
	@cp tools/qemu-$(HOST_ARCH)-static-wrap $(DIRECTORY)/qemu-arm-static-wrap
	time docker build  -f $(DIRECTORY)/Dockerfile.x86_64 -t $(NAME):$(VERSION) --rm $(DIRECTORY)
else
build: copy_commons
	time docker build -t $(NAME):$(VERSION) --rm $(DIRECTORY)
endif

test:
ifneq ($(HOST_NOT_ARM),1)
	# Need to be on the same host as docker daemon, because we mount shared test
	# directory...
	env NAME=$(NAME) VERSION=$(VERSION) ./test/runner.sh
else
	@echo "Tests skipped... need to be adapted to run on non ARM host"
endif

tag_latest:
	cd $(DIRECTORY)
	docker tag -f $(NAME):$(VERSION) $(NAME):latest

release: test tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! head -n 1 Changelog.md | grep -q 'release date'; then echo 'Please note the release date in Changelog.md.' && false; fi
	docker push $(NAME)
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"
