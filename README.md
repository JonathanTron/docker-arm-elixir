# Elixir docker images

Configuration to generate [Docker](https://www.docker.com) images with [elixir](http://elixir-lang.org) pre-installed for `armv6` (Raspberry Pi A/B/B+)/`armv7` (Raspberry Pi 2) architectures.

- `armv7l-archlinux-elixir`: image based on `armv7/armhf-archlinux`
- `armv6l-archlinux-elixir`: image based on `digitallyseamless/archlinux-armv6`

# Use the images

The goal is to provide some images based on various distributions available for ARM tagged based on the Elixir release included

  - For Archlinux with elixir 1.0.3, the tagged image will be: `jonathantron/armv7l-archlinux-elixir:1.0.3`

You can use those images directly:

```bash
# Start an iex session, deleting the container once you exit
docker run -ti --rm jonathantron/armv7l-archlinux-elixir:1.0.3 iex
```

Or you can choose to use them to build you own via `Dockerfile`:

```dockerfile
# For stable build, depends on tagged release
FROM jonathantron/armv7l-archlinux-elixir:1.0.3

MAINTAINER You <you@yourdomain.tld>

# your image specific elements
```

# Generate an image

There are currently three ways to generate the image:

1. Directly from an ARM host, running both `Docker client` and `Docker daemon`:

  ```bash
  # connect to the ARM host (either via ssh or using the console if you have a keyboard/mouse/screen connected to it)
  git clone https://github.com/JonathanTron/docker-arm-elixir.git
  cd docker-armhf-elixir
  # Build the image
  make build
  # Run some tests to ensure elixir works as expected
  make test
  # When ready you can tag a release
  make release
  ```

2. From a host running the `Docker client`, controlling `Docker daemon` on an ARM host:

  ```bash
  # On your machine, ensure you have Docker client configured to talk to Docker daemon on your ARM host
  # Replace IP by your ARM host ip address
  # Replace PORT by your ARM host's docker port
  export DOCKER_HOST=tcp://IP:PORT
  # Clone this repository
  git clone https://github.com/JonathanTron/docker-arm-elixir.git
  cd docker-armhf-elixir
  # Build the image
  make build
  # Run some tests to ensure elixir works as expected
  make test
  # When ready you can tag a release
  make release
  ```

3. Using a Vagrant box (`x86_64`), running `Docker daemon` and `Docker client`, using `qemu-user-static` to generate an ARM image:

   **WARNING**

   This option is slower than generating the image on an ARM host. But at least you can generate an image even when you have no access to an ARM host.

   ```bash
   # Clone this repository
   git clone https://github.com/JonathanTron/docker-arm-elixir.git
   cd docker-armhf-elixir
   # Boot the Vagrant VM and connect via ssh
   vagrant up
   vagrant ssh
   # Build the image, specifying which arch to target: 'armv7l' (Raspberry PI 2) or 'armv6l' (Raspberry PI A/B/B+)
   make build HOST_ARCH=armv7l
   # Run some tests to ensure elixir works as expected
   make test
   # When ready you can tag a release
   make release
   ```

# Credits

This project layout and some scripts (`Makefile` and `test/*`) are heavily influenced by [Phusion's baseimage-docker](https://github.com/phusion/baseimage-docker) project.
