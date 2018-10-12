CLANG ?= clang
CFLAGS ?=

CFLAGS += -Os -g3 -Wall -Wextra -Wno-unused-parameter
INCLUDES += -Ibuild/

all: build/libhttp_parser.a

clean:
	rm -rf build/

build/libhttp_parser.a: build/c/http_parser.o build/native/api.o \
		build/native/http.o
	$(AR) rcs $@ build/c/http_parser.o build/native/api.o build/native/http.o

build/bitcode/http_parser.o: build/bitcode/http_parser.bc
	$(CLANG) $(CFLAGS) -c $< -o $@

build/c/http_parser.o: build/c/http_parser.c
	$(CLANG) $(CFLAGS) $(INCLUDES) -c $< -o $@

build/native/%.o: src/native/%.c build/http_parser.h src/native/api.h \
		build/native
	$(CLANG) $(CFLAGS) $(INCLUDES) -c $< -o $@

build/http_parser.h: gen
build/bitcode/http_parser.bc: gen
build/c/http_parser.c: gen

build/native:
	mkdir -p build/native

gen:
	./bin/build.ts

.PHONY: all gen clean
