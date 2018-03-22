
COMPILE_CROSS=/opt/gcc-linaro-6.3.1-2017.02-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
CC=$(COMPILE_CROSS)gcc
target=irsend

obj=irsend.o


$(target): $(obj)
	$(CC) $^ -o $@

%.o:%.c
	$(CC) -c $< -o $@

clean:
	rm -rf *.o $(target)
