CC=clang
FRAMEWORKS=-framework Cocoa -framework DFRFoundation -F /System/Library/PrivateFrameworks
CFLAGS=-mmacosx-version-min=10.12 -x objective-c
LDFLAGS=-fobjc-link-runtime $(FRAMEWORKS)
SOURCES=touchbar_time.m
OBJECTS=touchbar_time.o
OUT=touchbar_time
BUNDLE=touchbar_time.app

all: $(SOURCES) $(OUT)
	@mkdir -p "$(BUNDLE)/Contents/MacOS"
	@cp "$(OUT)" "$(BUNDLE)/Contents/MacOS/"
	@cp Info.plist "$(BUNDLE)/Contents"

run: all kill
	@open "$(BUNDLE)"

$(OUT): $(OBJECTS)
	$(CC) $(OBJECTS) $(LDFLAGS) -o $(OUT)

.m.o:
	$(CC) -c $(CFLAGS) $< -o $@

kill:
	@pkill $(OUT) ; true

clean:
	@rm -f *~ $(OUT) *.o
	@rm -rf "$(BUNDLE)"
