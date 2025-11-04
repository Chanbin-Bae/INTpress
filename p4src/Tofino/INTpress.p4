/* -*- P4_16 -*- */
#include <core.p4>
#include <tna.p4>

#include "include/header.p4"
#include "include/parser.p4"

/**********************************************************
************************* Ingress *************************
**********************************************************/

control SwitchIngress(inout headers hdr, 
		      inout ingress_metadata_t ig_md, 
		      in ingress_intrinsic_metadata_t ig_intr_md, 
		      in ingress_intrinsic_metadata_from_parser_t ig_prsr_md, 
		      inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md, 
		      inout ingress_intrinsic_metadata_for_tm_t ig_tm_md) {

	#include "include/ingress_action.p4"
	#include "include/ingress_table.p4"

	/**********************************************************
	********************** Switch Logic ***********************
	**********************************************************/

	apply{
		tb_set_source.apply();
		tb_set_switch_id.apply();

		hdr.local_report_header.setValid();
		hdr.local_report_header.ingress_port_id = (bit<16>) ig_intr_md.ingress_port;
		hdr.local_report_header.queue_id = (bit<8>) ig_tm_md.qid;
		hdr.local_report_header.ingress_global_tstamp = ig_intr_md.ingress_mac_tstamp;

		if (ig_md.meta.source == 1){
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

control SwitchEgress(inout headers hdr, 
					inout egress_metadata_t eg_md, 
					in egress_intrinsic_metadata_t eg_intr_md, 
					in egress_intrinsic_metadata_from_parser_t eg_prsr_md, 
					inout egress_intrinsic_metadata_for_deparser_t eg_dprsr_md, 
					inout egress_intrinsic_metadata_for_output_port_t eg_oport_md) {
	
	#include "include/egress_action.p4"
	#include "include/egress_table.p4"

	/**********************************************************
	********************** Switch Logic ***********************
	**********************************************************/
	
	apply {
		// stage 1
		tb_bit_shift.apply();

		// stage 2
		tb_encoding_queue1.apply();
		// stage 3
		tb_encoding_queue2.apply();
		
		// stage 4
		tb_prepare.apply();

		// stage 5
		tb_update_space.apply();
	}
}

/**********************************************************
************************* Pipeline ************************
**********************************************************/

Pipeline(SwitchIngressParser(),
	SwitchIngress(),
	SwitchIngressDeparser(),
	SwitchEgressParser(),
	SwitchEgress(),
	SwitchEgressDeparser()
) pipe;

Switch(pipe) main;
