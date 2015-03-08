DISTRIB = archlinux
ELIXIR_BRANCH = 1.0.x
DIRECTORY = $(DISTRIB)-$(ELIXIR_BRANCH)
NAME = jonathantron/armhf-$(DISTRIB)-elixir
VERSION = 1.0.3

.PHONY: all build test tag_latest release

all: build

build:
	docker build -t $(NAME):$(VERSION) --rm $(DIRECTORY)

test:
	# Need to be on the same host as docker daemon, because we mount shared test
	# directory...
	# env NAME=$(NAME) VERSION=$(VERSION) ./test/runner.sh

tag_latest:
	cd $(DIRECTORY)
	docker tag -f $(NAME):$(VERSION) $(NAME):latest

release: test tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! head -n 1 Changelog.md | grep -q 'release date'; then echo 'Please note the release date in Changelog.md.' && false; fi
	docker push $(NAME)
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"
