CSRC := $(shell find src -name "*.c")
COBJ := $(CSRC:.c=.o)
CDEPS := $(CSRC:.c=.d)

LIB := mongoose

OPT += -O2
LFLAGS = -lm -lpthread -Llib/nvml/lib64 -lnvidia-ml
CFLAGS = -ggdb -Wall -Wextra -pedantic -std=c99 -D_BSD_SOURCE
IFLAGS = -Ilib/nvml/include -Ilib/mongoose -Iinclude

all: cudamond

cudamond: $(LIB) $(COBJ)
	$(CC) $(COBJ) lib/mongoose/mongoose.o $(LFLAGS) -o cudamond

%.o: %.c
	$(CC) -c -MMD $(CFLAGS) $(IFLAGS) $(OPT) $< -o $@

mongoose: lib/mongoose/mongoose.o

lib/mongoose/mongoose.o: lib/mongoose/mongoose.c
	$(CC) -c -std=c99 -O2 -W -Wall -pedantic -pthread $< -o $@

clean:
	rm -f $(COBJ) $(DEPS) cudamond

dist-clean: clean
	rm -f lib/mongoose/mongoose.o

todo:
	@find . -type f | xargs egrep -n --color=auto 'XXX|TODO|FIXME'

analyze:
	clang --analyze $(CFLAGS) $(IFLAGS) src/*.c

check-syntax:
	$(CC) -o /dev/null $(CFLAGS) -S $(CHK_SOURCES)
