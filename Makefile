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
SOURCE_DIR := ./src

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

define obj_for
	$(OBJS_DIR)/$(basename ${1}).o
endef

define mkdir_for
	@mkdir -p "$(dir ${1})"
endef

define syffixes_for
	$(foreach item,${2},$(addsuffix $(item),${1}))
endef


MAIN_FULLNAME := $(SOURCE_DIR)/$(MAIN)
MAIN_FULLNAME_VARIANTS := $(call syffixes_for,$(MAIN_FULLNAME), .c .cpp .s)
MAIN_OBJ_FULLNAME := $(call obj_for,$(MAIN))

SOURCES := $(shell find $(SOURCE_DIR) -name '*.cpp' -or -name '*.c' -or -name '*.s')

MODULES_SOURCES := $(filter-out $(MAIN_FULLNAME_VARIANTS),$(SOURCES))
MODULES_SOURCES_BASENAMES := $(foreach item,$(MODULES_SOURCES),$(item:$(SOURCE_DIR)/%=%))

MODULES_OBJ_FULLNAMES := $(foreach item,$(MODULES_SOURCES_BASENAMES), $(call obj_for,$(item)))
OBJS_FULLNAMES := $(MAIN_OBJ_FULLNAME) $(MODULES_OBJ_FULLNAMES)

BIN_FULLNAME := $(BUILD_DIR)/$(BIN)

# Link object files to the executable program
$(BIN_FULLNAME) : ${OBJS_FULLNAMES} | $(BUILD_DIR)
	$(CC) $(LDFLAGS) $(DEFS) $(LIBS) $(OBJS_FULLNAMES) -o $(BUILD_DIR)/$(BIN)

# Compiles main object file
$(MAIN_OBJ_FULLNAME): $(OBJS_DIR)/%.o: $(SOURCE_DIR)/%.c
	$(call mkdir_for,$@)
	$(CC) -c $(CFLAGS) $(DEFS) $< -o $@

# Compiles modules object files
$(MODULES_OBJ_FULLNAMES): $(OBJS_DIR)/%.o: $(SOURCE_DIR)/%.c $(SOURCE_DIR)/%.h
	$(call mkdir_for,$@)
	$(CC) -c $(CFLAGS) $(DEFS) $< -o $@

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

.PHONY: clean

clean:
	@if test -d ${OBJS_DIR}; then rm -r ${OBJS_DIR}; fi
	@if test -d ${BUILD_DIR}; then rm -r ${BUILD_DIR}; fi

rebuild: clean $(BIN_FULLNAME)

run: $(BIN_FULLNAME)
	$(BIN_FULLNAME)

## Debuging

# After macro expanding
$(patsubst %,preprocessed-%.c,$(MODULES_SOURCES_BASENAMES) $(MAIN)): preprocessed-%.c: $(SOURCE_DIR)/%.c
	$(CC) -E $(SOURCE_DIR)/$*.c

# Read compiled files
$(patsubst %,compiled-%.o,$(MODULES_SOURCES_BASENAMES)): compiled-%.o : $(OBJS_DIR)/$(BIN)
	objdump -D $(OBJS_DIR)/$*.o

# run with gdb
gdb: $(BIN_FULLNAME)
	gdb $(BIN_FULLNAME)

