ifeq ($(strip $(ENV)),)
	export ENV=production
endif

# Compiler flags: all warnings + debugger meta-data
CFLAGS = -Wall -Wextra
LDFLAGS = -Wall -Wextra

ifeq ($(ENV),development)
	CFLAGS += -g -fsanitize=address
	LDFLAGS += -g -fsanitize=address -static-libasan
endif

# Main directories
SOURCE_DIR := src

BUILD_DIR := ./build
OBJS_DIR := $(BUILD_DIR)/obj

# External libraries: only math in this example
LIBS = -lm

# Pre-defined macros for conditional compilation
DEFS = -DDEBUG_FLAG -DEXPERIMENTAL=0

# The final executable program file, i.e. name of our program
BIN = bin

# Program root file
MAIN = main
# Object files from which $BIN depends

MODULES := lib/module1


define obj_for
	$(OBJS_DIR)/${1}.o
endef

define obj_for_list
	$(foreach var,"${1}",$(call obj_for,$(var)))
endef

define mkdir_for
	@mkdir -p "$(shell dirname ${1})"
endef

MAIN_FULLNAME := $(SOURCE_DIR)/$(MAIN)
OBJS_FULLNAMES := $(patsubst %,$(OBJS_DIR)/%.o,$(MAIN) $(MODULES))
BIN_FULLNAME := $(BUILD_DIR)/$(BIN)


# Link object files to the executable program
$(BIN_FULLNAME) : ${OBJS_FULLNAMES} | $(BUILD_DIR)
	$(CC) $(LDFLAGS) $(DEFS) $(LIBS) $(OBJS_FULLNAMES) -o $(BUILD_DIR)/$(BIN)

# Compiles main object file
$(OBJS_DIR)/$(MAIN).o: $(OBJS_DIR)/%.o: $(SOURCE_DIR)/%.c
	$(call mkdir_for,$@)
	$(CC) -c $(CFLAGS) $(DEFS) $< -o $@

# Compiles modules object files
$(OBJS_DIR)/%.o: $(SOURCE_DIR)/%.c $(SOURCE_DIR)/%.h
	$(call mkdir_for,$@)
	$(CC) -c $(CFLAGS) $(DEFS) $< -o $@

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

.PHONY: clean

clean:
	@if test -d ${OBJS_DIR}; then rm -r ${OBJS_DIR}; fi
	@if test -d ${BUILD_DIR}; then rm -r ${BUILD_DIR}; fi

# After macro expanding
$(patsubst %,preprocessed-%.c,$(MODULES) $(MAIN)): preprocessed-%.c: $(SOURCE_DIR)/%.c
	$(CC) -E $(SOURCE_DIR)/$*.c

# Read compiled files
$(patsubst %,compiled-%.o,$(MODULES)): compiled-%.o : $(OBJS_DIR)/$(BIN)
	objdump -D $(OBJS_DIR)/$*.o

run: $(BIN_FULLNAME)
	$(BIN_FULLNAME)

rebuild: clean $(BIN_FULLNAME)

# run with gdb
gdb: $(BIN_FULLNAME)
	gdb $(BIN_FULLNAME)

