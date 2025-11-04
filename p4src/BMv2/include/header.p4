/* -*- P4_16 -*- */
#include <core.p4>
#include <v1model.p4>

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

struct headers {
	ethernet_t   ethernet;
	ipv4_t       ipv4;
	
    INTpressNum_t INTpressNum;
    INTpressSpace_t INTpressSpace;

    INTpress_t[4] INTpress;
    stacked_t stacked;
}

struct metadata {
    bit<7> padding3;
    bit<1> source;

    bit<32> switch_id;

	bit<32> queue_occupancy;
    
	bit<32> queue_occupancy_shift1;
	bit<32> queue_occupancy_shift3;

    bit<8> delta;
    bit<8> encoding_level;
    bit<32> encoding_bit;
    
    bit<32> test;
    bit<32> pre_val;
}