/* -*- P4_16 -*- */
#include <core.p4>
#include <tna.p4>


#define INT 20 //FAT_INT
const bit<16> TYPE_IPV4 = 0x800;

typedef bit<9>  egressSpec_t;
typedef bit<48> macAddr_t;
typedef bit<32> ip4Addr_t;

/**********************************************************
************************** Header *************************
**********************************************************/

header ethernet_t {
		macAddr_t dstAddr;
		macAddr_t srcAddr;
		bit<16>   etherType;
}

header ipv4_t {
		bit<4>    version;
		bit<4>    ihl;
		bit<8>    dscp;
		bit<16>   totalLen;
		bit<16>   identification;
		bit<3>    flags;
		bit<13>   fragOffset;
		bit<8>    ttl;
		bit<8>    protocol;
		bit<16>   hdrChecksum;
		ip4Addr_t srcAddr;
		ip4Addr_t dstAddr;
}

header tcp_t {
    bit<16> srcPort;
    bit<16> dstPort;
    bit<32> seqNo;
    bit<32> ackNo;
    bit<4>  dataOffset;
    bit<3>  res;
    bit<3>  ecn;
    bit<6>  ctrl;
    bit<16> window;
    bit<16> checksum;
    bit<16> urgentPtr;
}

header INTpressNum_t {
	bit<8> INTpressNum;
}

header INTpressSpace_t {
	bit<8> INTpressSpace;
}

header INTpress_t{
    bit<8> INTpressData;
}

header stacked_t{
    varbit<24> stackeed_data;
}

header local_report_header_t {
    bit<16> ingress_port_id;
    bit<8>  queue_id;
    bit<48> ingress_global_tstamp;
}

struct headers {
	ethernet_t   ethernet;
	ipv4_t       ipv4;
	tcp_t		 tcp;
	
	local_report_header_t local_report_header; // check!

    INTpressNum_t INTpressNum;
    INTpressSpace_t INTpressSpace;

    INTpress_t[4] INTpress;
    stacked_t stacked;
}

header metadata_t {
    bit<7> padding;
    bit<1> source;

    bit<32> switch_id;

    bit<32> encoding_bit;
    
    bit<32> test;
    bit<32> pre_val;
    
    bit<8> delta;
    bit<8> encoding_level;
    
    
	bit<16> queue_shift1;
    bit<16> queue_shift2;
}

struct ingress_metadata_t {
    metadata_t meta;
}

struct egress_metadata_t {
    metadata_t meta;
}