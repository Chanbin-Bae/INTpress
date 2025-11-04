
/**********************************************************
********************** Ingress Parser *********************
**********************************************************/

parser SwitchIngressParser(packet_in packet,
                           out headers hdr,
                           out ingress_metadata_t ig_md,
                           out ingress_intrinsic_metadata_t ig_intr_md) {
		state start {
            packet.extract(ig_intr_md);
            packet.advance(PORT_METADATA_SIZE);

            transition parse_ethernet;
		}

        state parse_ethernet {
				packet.extract(hdr.ethernet);
				packet.extract(hdr.ipv4);
				packet.extract(hdr.tcp);
				ig_md.meta.setValid();
				transition select (hdr.ipv4.dscp){
					INT: INTpress;
					default: accept;
				}
		}
        
        state INTpress {
            packet.extract(hdr.INTpressNum);
            packet.extract(hdr.INTpressSpace);
            transition select (hdr.INTpressSpace.INTpressSpace){
                8 : INTpress1;
                16 : INTpress2;
                24 : INTpress3;
                32 : INTpress4;
                default : accept;
            }
        }

        state INTpress1 {
            packet.extract(hdr.INTpress.next);
            transition  accept;
        }

        state INTpress2 {
            packet.extract(hdr.INTpress.next);
            packet.extract(hdr.INTpress.next);
            transition  accept;
        }

        state INTpress3 {
            packet.extract(hdr.INTpress.next);
            packet.extract(hdr.INTpress.next);
            packet.extract(hdr.INTpress.next);
            transition  accept;
        }

        state INTpress4 {
            // packet.extract(hdr.INTpress.next);
            // packet.extract(hdr.INTpress.next);
            // packet.extract(hdr.INTpress.next);
            packet.extract(hdr.INTpress[3]);
            packet.extract(hdr.stacked, 24);
            transition  accept;
        }
}

/**********************************************************
********************* Ingress Deparser ********************
**********************************************************/

control SwitchIngressDeparser(packet_out packet, 
                             inout headers hdr,
                             in ingress_metadata_t ig_md,
                             in ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md) {
		apply {
            packet.emit(ig_md.meta);
            packet.emit(hdr);
		}
}

/**********************************************************
********************** Egress Parser **********************
**********************************************************/

parser SwitchEgressParser(packet_in packet,
                          out headers hdr,
                          out egress_metadata_t eg_md, 
                          out egress_intrinsic_metadata_t eg_intr_md) {
        state start {
            packet.extract(eg_intr_md);
            packet.extract(eg_md.meta);
            transition parse_ethernet;
		}

        state parse_ethernet {
			packet.extract(hdr.ethernet);
			packet.extract(hdr.ipv4);
			packet.extract(hdr.tcp);
			transition select (hdr.ipv4.dscp){
				INT: INTpress;
				default: accept;
			}
		}
        
        state INTpress {
			packet.extract(hdr.local_report_header);
            packet.extract(hdr.INTpressNum);
            packet.extract(hdr.INTpressSpace);
            transition select (hdr.INTpressSpace.INTpressSpace){
                8 : INTpress1;
                16 : INTpress2;
                24 : INTpress3;
                32 : INTpress4;
                default : accept;
            }
        }
        
        state INTpress1 {
            packet.extract(hdr.INTpress.next);
            transition  accept;
        }

        state INTpress2 {
            packet.extract(hdr.INTpress.next);
			packet.extract(hdr.INTpress.next);
            transition  accept;
        }

        state INTpress3 {
            packet.extract(hdr.INTpress.next);
            packet.extract(hdr.INTpress.next);
            packet.extract(hdr.INTpress.next);
            transition  accept;
        }

        state INTpress4 {
            // packet.extract(hdr.INTpress.next);
            // packet.extract(hdr.INTpress.next);
            // packet.extract(hdr.INTpress.next);
            packet.extract(hdr.INTpress[3]);
            packet.extract(hdr.stacked, 24);
            transition  accept;
        }
}

/**********************************************************
********************** Egress Deparser ********************
**********************************************************/

control SwitchEgressDeparser(packet_out packet, 
                             inout headers hdr,
                             in egress_metadata_t eg_md, 
                             in egress_intrinsic_metadata_for_deparser_t eg_dprsr_md) {
		apply {
            packet.emit(hdr.ethernet);
            packet.emit(hdr.ipv4);
			packet.emit(hdr.tcp);
            packet.emit(hdr.INTpressNum);
            packet.emit(hdr.INTpressSpace);
            packet.emit(hdr.INTpress);
		}
}