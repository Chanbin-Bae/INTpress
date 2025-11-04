
#!/usr/bin/env python
import sys
import io
import os
import time
import argparse

from scapy.all import sniff
from scapy.all import IP, TCP, bind_layers
import threading

################################################################################################
##########                      Parsing customized packet headers                      #########
################################################################################################

class INTpress():
    def __init__(self):
        self.INTpressNum = None
        self.INTpressSpace = None

    @staticmethod
    def from_bytes(data):
        hdr = FatIntHeader()
        h = io.BytesIO(data)
        hdr.INTpressNum = int.from_bytes(h.read(1), byteorder='big')
        hdr.INTpressSpace = int.from_bytes(h.read(1), byteorder='big')
        return hdr

    def __str__(self):
        return str(vars(self))
    
def parse_INTpress_header(pkt):
    int_metadata = pkt[IP].load[:]
    meta = INTpressHeader.from_bytes(int_metadata)
    # print(meta)
    return meta

def parse_metadata(pkt, INTpressSpace,INTpressNum):
    int_metadata = pkt[IP].load[2:int(INTpressSpace/8)+2]
    final_int_metadata = int_metadata[(8-INTpressNum):]
    return final_int_metadata

def parsing_recv_packets(pkt):
    try:
        if pkt[IP].tos == 0x3:
            print("Normal Packet")
            count_normal +=1
        else:
            INTpressHdr = parse_INTpress_header(pkt)
            print(f"[INTpressNum, INTpressSpace] = [{INTpressHdr.INTpressNum}, {INTpressHdr.INTpressSpace}]")
            final_int_metadata = parse_metadata(pkt, INTpressHdr.INTpressSpace,INTpressHdr.INTpressNum)
            
    except Exception as e:
        print(f"Error parsing packet: {e}")


#################################################################################################
##########                           Receiving packet headers                           #########
#################################################################################################

def handle_pkt(pkt):
    global recv_pkts
    recv_pkts.append(pkt)

def receive_packet():
    global iface
    sniff(iface = iface, prn = lambda x: handle_pkt(x))

#################################################################################################
##########                                     main                                     #########
#################################################################################################

def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--file_path', help='Abs file path', type=str, required=True)
    return parser.parse_args()

def main():
    global iface
    recv_pkts = []

    args = get_args()

    init_time = time.time()

    file_name = f"{args.file_path}/INTpress/p4src/BMv2/example/packets/result.txt"
    sys.stdout = open(file_name,'w')

    ifaces = [i for i in os.listdir('/sys/class/net/') if 'eth' in i]
    iface = ifaces[0]

    receive_thread = threading.Thread(target=receive_packet, args=())
    receive_thread.daemon = True
    receive_thread.start()

    current_time = 0
    while current_time < 600:
        current_time = time.time()-init_time

    for pkt in recv_pkts:
        parsing_recv_packets(pkt)
    sys.exit()
    
if __name__ == '__main__':   
    main()