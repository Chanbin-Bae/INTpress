
/**********************************************************
********************** Ingress Parser *********************
**********************************************************/

parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {
        
        state start {
            packet.extract(hdr.ethernet);
            packet.extract(hdr.ipv4);

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
            packet.extract(hdr.INTpress[3]);
            packet.extract(hdr.stacked, 24);
            transition  accept;
        }
}

/**********************************************************
********************* Ingress Deparser ********************
**********************************************************/

control MyDeparser(packet_out packet, 
                   in headers hdr) {
		apply {
            packet.emit(hdr.ethernet);
            packet.emit(hdr.ipv4);
            packet.emit(hdr.INTpressNum);
            packet.emit(hdr.INTpressSpace);
            packet.emit(hdr.INTpress);
		}
}