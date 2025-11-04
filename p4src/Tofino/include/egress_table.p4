/**********************************************************
********************** Egress Table ***********************
**********************************************************/

table tb_bit_shift{
    actions = {
        bit_shift;
    }
    default_action = bit_shift();
    size = 1;
}

table tb_encoding_queue1 {
    key = {
        eg_md.meta.queue_shift1: exact;
    }
    actions = {
        encoding_queue1;
        NoAction();
    }
    const default_action = NoAction();
    size = 6721;
}

table tb_encoding_queue2 {
    key = {
        eg_md.meta.queue_shift2: exact;
    }
    actions = {
        encoding_queue2;
        NoAction();
    }
    const default_action = NoAction();
    size = 1272;
}

table tb_update_space {
    key = {
        eg_md.meta.delta : exact;
        eg_md.meta.encoding_level : exact;
    }
    actions = {
        update_space_0;
        update_space_1;
        update_space_2;
        update_space_3;
        set1;
        NoAction;
    }
    default_action = NoAction();
    size = 256;
}

table tb_prepare {
    key = {
        eg_md.meta.delta: exact;
    }
    actions ={
        prepare1;
        prepare2;
        prepare3;
        prepare4;
        prepare5;
        prepare6;
        prepare7;
        prepare8;
        NoAction;
    }
    default_action = NoAction();
    size = 8;
}