ifeq ($(strip $(ENV)),)
	export ENV=production
endif

# Compiler flags: all warnings + debugger meta-data
CFLAGS = -std=c17 -Wall -Wextra
LDFLAGS = -std=c17 -Wall -Wextra

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

ALL_SOURCES := $(shell find $(SOURCE_DIR) -name '*.cpp' -or -name '*.c' -or -name '*.s')
ALL_SOURCES_BASENAMES := $(foreach item,$(ALL_SOURCES),$(item:$(SOURCE_DIR)/%=%))

MODULES_SOURCES := $(filter-out $(MAIN_FULLNAME_VARIANTS),$(ALL_SOURCES))
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
	$(BIN_FULLNAME) $(filter-out $@, $(MAKECMDGOALS))

## Debuging

# After macro expanding
$(patsubst %,preprocessed-%,$(ALL_SOURCES_BASENAMES)): preprocessed-%:
	$(CC) -E $(SOURCE_DIR)/$*

# Read compiled files
$(patsubst $(OBJS_DIR)/%,compiled-%,$(OBJS_FULLNAMES)): compiled-%:
	objdump -D $(OBJS_DIR)/$*

# run with gdb
gdb: $(BIN_FULLNAME)
	gdb --args $(BIN_FULLNAME) $(filter-out $@, $(MAKECMDGOALS))

