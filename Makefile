TARGET := gpio_driver.ko

MDIR := arch/arm/gpio_driver

CURRENT := $(shell uname -r)
KDIR := /lib/modules/$(CURRENT)/build
PWD := $(shell pwd)
DEST := /lib/modules/$(CURRENT)/kernel/$(MDIR)

obj-m := gpio_driver.o

default:
	sudo rmmod gpio_driver
	$(MAKE) -I $(KDIR)/arch/arm/include/asm/ -C $(KDIR) M=$(PWD)
	sudo insmod gpio_driver.ko

install:
	#@if test -f $(DEST)/$(TARGET).orig; then \
	#       echo "Backup of .ko already exists."; \
	#else \
	#       echo "Creating a backup of .ko."; \
	#       mv -v $(DEST)/$(TARGET) $(DEST)/$(TARGET).orig; \
	#fi
	su -c "cp $(TARGET) $(DEST) && /sbin/depmod -a"

revert:
	@echo "Reverting to the original .ko."
	@mv -v $(DEST)/$(TARGET).orig $(DEST)/$(TARGET)

clean:
	rm -f *.o $(TARGET) .*.cmd .*.flags *.mod.c

-include $(KDIR)/Rules.make
