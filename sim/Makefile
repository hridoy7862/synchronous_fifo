# Configuration

TOP       = tb_top

RTL_DIR   = ../rtl
TB_DIR    = ../tb

#RTL_SRCS  = $(wildcard $(RTL_DIR)/*.sv)
#TB_SRCS   = $(wildcard $(TB_DIR)/*.sv)

#SRCS      = $(RTL_SRCS) $(TB_SRCS)
SRCS = \
    $(TB_DIR)/fifo_transaction.sv \
    $(TB_DIR)/fifo_if.sv \
    $(TB_DIR)/fifo_generator.sv \
    $(TB_DIR)/fifo_driver.sv \
    $(TB_DIR)/fifo_monitor.sv \
    $(TB_DIR)/fifo_scoreboard.sv \
    $(TB_DIR)/fifo_environment.sv \
    $(TB_DIR)/fifo_base_test.sv \
		$(TB_DIR)/fifo_basic_test.sv \
		$(TB_DIR)/fifo_full_test.sv \
		$(TB_DIR)/fifo_empty_test.sv \
		$(TB_DIR)/fifo_simultaneous_test.sv \
    $(TB_DIR)/tb_top.sv \
    $(RTL_DIR)/sync_fifo.sv

XVLOG     = xvlog
XELAB     = xelab
XSIM      = xsim

SNAPSHOT  = $(TOP)_snap

# Default Target

all: compile elaborate simulate

# Compile

compile:
	$(XVLOG) --sv $(SRCS)

# Elaborate

elaborate:
	$(XELAB) $(TOP) -snapshot $(SNAPSHOT)

# Simulate (Batch Mode)

simulate:
	$(XSIM) $(SNAPSHOT) -runall

# GUI Mode

gui:
	$(XSIM) $(SNAPSHOT) --gui

# Clean

clean:
	rm -rf xsim.dir *.jou *.log *.pb *.wdb

# Rebuild

rebuild: clean all

.PHONY: all compile elaborate simulate gui clean rebuild
