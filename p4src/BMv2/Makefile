#!/bin/bash
FILE_PATH="default"

PCAP_DIR 	= 	pcap
LOG_DIR 	= 	log


all: run

run: clean
	sudo python3 $(FILE_PATH)/INTpress/p4src/BMv2/example/network.py --p4 $(FILE_PATH)/INTpress/p4src/BMv2/INTpress.p4 --file_path $(FILE_PATH)

stop:
	sudo mn -c

clean: stop
	sudo rm -f *.pcap
	# rm -rf $(PCAP_DIR) $(LOG_DIR) $(RULE_DIR)/rule*
	sudo rm -rf $(PCAP_DIR) $(LOG_DIR)
