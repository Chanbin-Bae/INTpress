/**********************************************************
********************* Ingress Table ***********************
**********************************************************/

table tb_set_source {
    key = {
        hdr.ipv4.dscp : exact;
    }
    actions = {
        int_set_source;
        save_pre_val();
    }
    const default_action = save_pre_val();
}

table tb_set_switch_id {
    key = {
        hdr.ipv4.version:exact;
    }
    actions = {
        set_switch_id;
        NoAction();
    }
    const default_action = NoAction();
}

table tb_forward {
    key = {
        standard_metadata.ingress_port: exact;
    }
    actions = {
        set_egress_port;
        NoAction;
    }
    const default_action = NoAction();
}