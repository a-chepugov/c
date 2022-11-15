ifeq ($(strip $(ENV)),)
	export ENV=production
endif

# Compiler flags: all warnings + debugger meta-data
CFLAGS = -std=c17 -Wall -Wextra
LDFLAGS = -std=c17 -Wall -Wextra

ifeq ($(ENV),development)
	CFLAGS += -g
	LDFLAGS += -g
endif

# Main directories
SOURCES_DIR = src
TESTS_DIR = tests
BUILD_DIR = build
TARGETS_DIR = $(BUILD_DIR)
SHAREDS_DIR = $(BUILD_DIR)
OBJECTS_DIR = $(BUILD_DIR)/objects

# External libraries: only math in this example
LIBS = -lm

# Pre-defined macros for conditional compilation
DEFS = -DDEBUG_FLAG -DEXPERIMENTAL=0

# Object files from which $BIN depends

define mkdir_for
	@mkdir -p "$(dir ${1})"
endef

ENTRIES = $(wildcard $(SOURCES_DIR)/*.c)
MODULES = $(wildcard $(SOURCES_DIR)/**/*.c)
SOURCES = $(ENTRIES) $(MODULES)
ENTRIES_OBJECTS = $(patsubst $(SOURCES_DIR)/%.c,$(OBJECTS_DIR)/%.o,$(ENTRIES))
MODULES_OBJECTS = $(patsubst $(SOURCES_DIR)/%.c,$(OBJECTS_DIR)/%.o,$(MODULES))
OBJECTS = $(ENTRIES_OBJECTS) $(MODULES_OBJECTS)
TARGETS = $(patsubst $(SOURCES_DIR)/%.c,$(TARGETS_DIR)/%.a,$(ENTRIES))
SHAREDS = $(patsubst $(SOURCES_DIR)/%.c,$(SHAREDS_DIR)/%.so,$(ENTRIES))

TESTS = $(wildcard $(TESTS_DIR)/*.c, $(TESTS_DIR)/**/*.c)

all: echo check $(TARGETS) tests

echo :
	@echo ENV: $(ENV)
	@echo TESTS: $(TESTS)
	@echo ENTRIES: $(ENTRIES)
	@echo MODULES: $(MODULES)
	@echo OBJECTS: $(OBJECTS)
	@echo TARGETS: $(TARGETS)
	@echo  - - - - - - - - - -

# Link object files to the executable program
$(TARGETS) : % : $(OBJECTS)
	@echo build target $@
	$(call mkdir_for,$@)
	$(CC) $(LDFLAGS) $(DEFS) $(LIBS) $(OBJECTS) -o $@

# Create shared library
$(SHAREDS) : % : $(OBJECTS)
	@echo build shared $@
	$(call mkdir_for,$@)
	$(CC) $(LDFLAGS) $(DEFS) $(LIBS) $(OBJECTS) -shared -o $@

# Compiles object files
$(MODULES_OBJECTS) : $(OBJECTS_DIR)/%.o : $(SOURCES_DIR)/%.c $(SOURCES_DIR)/%.h
	@echo build object $@ with: $<
	$(call mkdir_for,$@)
	$(CC) -c $(CFLAGS) $(DEFS) $< -o $@

# Compiles object files
$(ENTRIES_OBJECTS) : $(OBJECTS_DIR)/%.o : $(SOURCES_DIR)/%.c
	@echo build object $@ with: $<
	$(call mkdir_for,$@)
	$(CC) -c $(CFLAGS) $(DEFS) $< -o $@

tests:
	@echo tests

.PHONY: clean

clean:
	@if test -d ${SHAREDS_DIR}; then rm -r ${SHAREDS_DIR}; fi;
	@if test -d ${TARGETS_DIR}; then rm -r ${TARGETS_DIR}; fi;
	@if test -d ${OBJECTS_DIR}; then rm -r ${OBJECTS_DIR}; fi;
	@if test -d ${BUILD_DIR}; then rm -r ${BUILD_DIR}; fi;
	@echo cleaned;

rebuild: clean all

# Debuging

## After macro expanding
$(patsubst $(SOURCES_DIR)/%,preprocessed-%,$(SOURCES)) : preprocessed-% :
	$(CC) -E $(SOURCES_DIR)/$*

## Read object files
$(patsubst $(OBJECTS_DIR)/%,compiled-%,$(OBJECTS)) : compiled-%: $(OBJECTS_DIR)/%
	objdump -D $(OBJECTS_DIR)/$*

## Search dangerous functions
check :
	@echo Files with potentially dangerous functions
	@egrep '[^_.>a-zA-Z0-9](str(n?cpy|n?cat|xfrm|n?dup|str|pbrk|tok|_)|stpn?cpy|a?sn?printf|byte_)' $(SOURCES) || true

## run
$(patsubst $(TARGETS_DIR)/%,run-%,$(TARGETS)) : run-% : $(TARGETS_DIR)/%
	@echo run $*
	$(TARGETS_DIR)/$* $(filter-out $@,$(MAKECMDGOALS))

## run with gdb
$(patsubst $(TARGETS_DIR)/%,gdb-%,$(TARGETS)) : gdb-% : $(TARGETS_DIR)/%
	@echo gdb $*
	gdb --args $(TARGETS_DIR)/$* $(filter-out $@,$(MAKECMDGOALS))

## run with valgrind
$(patsubst $(TARGETS_DIR)/%,valgrind-%,$(TARGETS)) : valgrind-% : $(TARGETS_DIR)/%
	@echo valgrind $*
	valgrind -s --leak-check=full $(TARGETS_DIR)/$* $(filter-out $@,$(MAKECMDGOALS))

## run with ddd
$(patsubst $(TARGETS_DIR)/%,ddd-%,$(TARGETS)) : ddd-% : $(TARGETS_DIR)/%
	@echo ddd $*
	ddd $(TARGETS_DIR)/$* $(filter-out $@,$(MAKECMDGOALS))
