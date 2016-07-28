NAME	 = gobuilder
TAG	 = latest
FULLNAME = $(NAME):$(TAG)

default: build export clean

build:
	docker build -t $(FULLNAME) .

export:
	mkdir -p rootfs
	docker export -o rootfs.tar `docker run --name $(NAME) -d $(FULLNAME) sleep 180`
	tar xf rootfs.tar -C rootfs
	mv rootfs/usr/local/bin/* bin/

clean:
	rm -rf rootfs rootfs.tar
	docker stop $(NAME)
	docker rm $(NAME)
	docker rmi $(FULLNAME)
