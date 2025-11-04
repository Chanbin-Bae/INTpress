/* -*- P4_16 -*- */
#include <core.p4>
#include <v1model.p4>

#define INT 20

#include "include/header.p4"
#include "include/parser.p4"

control MyVerifyChecksum(inout headers hdr, inout metadata meta) {
		apply {  }
}


control MyComputeChecksum(inout headers hdr, inout metadata meta) {
		apply {

		}
}

/**********************************************************
************************* Ingress *************************
**********************************************************/

control MyIngress(inout headers hdr,
				  inout metadata meta,
				  inout standard_metadata_t standard_metadata) {

	#include "include/ingress_action.p4"
	#include "include/ingress_table.p4"

	/**********************************************************
	********************** Switch Logic ***********************
	**********************************************************/

	apply{
		tb_set_source.apply();
		tb_set_switch_id.apply();

		if (meta.source == 1){
			valid_header();
		}
		else{
			save_pre_val();
		}
		
		tb_forward.apply();
	}
}

/**********************************************************
************************** Egress *************************
**********************************************************/

control MyEgress(inout headers hdr,
			 	 inout metadata meta,
			 	 inout standard_metadata_t standard_metadata) {
	
	#include "include/egress_action.p4"
	#include "include/egress_table.p4"

	/**********************************************************
	********************** Switch Logic ***********************
	**********************************************************/
	
	apply {
		meta.queue_occupancy = (bit<32>) standard_metadata.deq_qdepth;

		tb_bit_shift.apply();

		tb_encoding_queue1.apply();
		tb_encoding_queue3.apply();
		
		tb_prepare.apply();

		tb_update_space.apply();
	}
}

/**********************************************************
************************* Pipeline ************************
**********************************************************/

V1Switch(
		MyParser(),
		MyVerifyChecksum(),
		MyIngress(),
		MyEgress(),
		MyComputeChecksum(),
		MyDeparser()
) main;