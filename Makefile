# Compiler flags: all warnings + debugger meta-data
CFLAGS = -Wall -Wextra -g

# Main directories
SOURCE_DIR=./src
LIBS_DIR =$(SOURCE_DIR)/lib

BUILD_DIR=./build
OBJS_DIR=$(BUILD_DIR)


# External libraries: only math in this example
LIBS = -lm

# Pre-defined macros for conditional compilation
DEFS = -DDEBUG_FLAG -DEXPERIMENTAL=0

# The final executable program file, i.e. name of our program
BIN = bin
MAIN = main

# Object files from which $BIN depends
MODULES = module1
_OBJS = $(patsubst %,$(OBJS_DIR)/%.o,$(MODULES))

# This default rule compiles the executable program
$(BUILD_DIR)/$(BIN) : ${_OBJS} $(SOURCE_DIR)/$(MAIN).c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) $(DEFS) $(LIBS) $(_OBJS) $(SOURCE_DIR)/$(MAIN).c -o $(BUILD_DIR)/$(BIN)

# This rule compiles each module into its object file
$(OBJS_DIR)/%.o : $(SOURCE_DIR)/%.c $(SOURCE_DIR)/%.h
	@mkdir -p $(OBJS_DIR)
	$(CC) -c $(CFLAGS) $(DEFS) $< -o $@

.PHONY: clean

clean:
	@if test -d ${OBJS_DIR}; then rm -r  ${OBJS_DIR}; fi
	@if test -d ${BUILD_DIR}; then rm -r  ${BUILD_DIR}; fi

# After macro expanding
$(patsubst %,preprocessed-%.c,$(MODULES)) preprocessed-$(MAIN).c : preprocessed-%.c : $(SOURCE_DIR)/%.c
	$(CC) -E $(SOURCE_DIR)/$*.c

# Compiled files
$(patsubst %,compiled-%.o,$(MODULES)) : compiled-%.o : $(OBJS_DIR)/$(BIN)
	objdump -D $(OBJS_DIR)/$*.o
