/**********************************************************
********************* Ingress Action **********************
**********************************************************/

action int_set_source () {
    meta.source = 1;
    hdr.ipv4.dscp = INT;
}	

action set_switch_id(bit<32> switch_id){
    meta.switch_id = switch_id;
}

action set_egress_port(bit<9> port) {
    standard_metadata.egress_spec = port;
    hdr.ipv4.ttl=hdr.ipv4.ttl-1;
}

action valid_header(){
    hdr.INTpressNum.setValid();
    hdr.INTpressSpace.setValid();
}

action save_pre_val() {
    meta.pre_val = (bit<32>) hdr.INTpress[0].INTpressData;
    meta.delta = hdr.INTpressSpace.INTpressSpace - hdr.INTpressNum.INTpressNum;
}