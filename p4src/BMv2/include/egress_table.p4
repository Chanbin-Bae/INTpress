/**********************************************************
********************** Egress Table ***********************
**********************************************************/

table tb_bit_shift{
    actions = {
        bit_shift;
    }
    default_action = bit_shift();
}

table tb_encoding_queue1 {
    key = {
        meta.queue_occupancy_shift1: exact;
    }
    actions = {
        encoding_queue1;
        NoAction();
    }
    const default_action = NoAction();
}

table tb_encoding_queue3 {
    key = {
        meta.queue_occupancy_shift3: exact;
    }
    actions = {
        encoding_queue3;
        NoAction();
    }
    const default_action = NoAction();
}

table tb_update_space {
    key = {
        meta.delta : exact;
        meta.encoding_level : exact;
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
}

table tb_prepare {
    key = {
        meta.delta: exact;
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
    const entries = {
        (1) : prepare1();
        (2) : prepare2();
        (3) : prepare3();
        (4) : prepare4();
        (5) : prepare5();
        (6) : prepare6();
        (7) : prepare7();
        (0) : prepare8();
    }
}