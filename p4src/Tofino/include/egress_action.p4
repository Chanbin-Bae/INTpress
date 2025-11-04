/**********************************************************
********************* Egress Action ***********************
**********************************************************/

action bit_shift(){
    eg_md.meta.queue_shift1 = (bit<16>) eg_intr_md.enq_qdepth;//2
    eg_md.meta.queue_shift2 = (bit<16>) eg_intr_md.enq_qdepth >> 2;//2
}

action encoding_queue1(bit<8> encoding_level, bit<32> encoding_bit){
    eg_md.meta.encoding_level = encoding_level;
    eg_md.meta.encoding_bit = encoding_bit;
}

action encoding_queue2(bit<8> encoding_level, bit<32> encoding_bit){
    eg_md.meta.encoding_level = encoding_level;
    eg_md.meta.encoding_bit = encoding_bit;
}

action update_space_0() {
    hdr.INTpressSpace.INTpressSpace = hdr.INTpressSpace.INTpressSpace + 8;
    hdr.INTpress.push_front(1);
    hdr.INTpress[0].setValid();

    hdr.INTpress[0].INTpressData = (bit<8>) (eg_md.meta.test);
}

action update_space_1() {
    hdr.INTpressSpace.INTpressSpace = hdr.INTpressSpace.INTpressSpace + 8;
    hdr.INTpress.push_front(1);
    hdr.INTpress[0].setValid();

    eg_md.meta.test = eg_md.meta.test | eg_md.meta.pre_val;
    hdr.INTpress[1].INTpressData = (bit<8>) (eg_md.meta.test);
    hdr.INTpress[0].INTpressData = (bit<8>) (eg_md.meta.test >> 8);
}

action update_space_2() {
    hdr.INTpressSpace.INTpressSpace = hdr.INTpressSpace.INTpressSpace + 16;
    hdr.INTpress.push_front(2);
    hdr.INTpress[0].setValid();
    hdr.INTpress[1].setValid();

    eg_md.meta.test = eg_md.meta.test | eg_md.meta.pre_val;
    hdr.INTpress[2].INTpressData = (bit<8>) eg_md.meta.test;
    hdr.INTpress[1].INTpressData = (bit<8>) (eg_md.meta.test >> 8);
    hdr.INTpress[0].INTpressData = (bit<8>) (eg_md.meta.test >> 16);
}

action update_space_3() {
    hdr.INTpressSpace.INTpressSpace = hdr.INTpressSpace.INTpressSpace + 24;
    hdr.INTpress.push_front(3);
    hdr.INTpress[0].setValid();
    hdr.INTpress[1].setValid();
    hdr.INTpress[2].setValid();

    eg_md.meta.test = eg_md.meta.test | eg_md.meta.pre_val;
    hdr.INTpress[3].INTpressData = (bit<8>) eg_md.meta.test;
    hdr.INTpress[2].INTpressData = (bit<8>) (eg_md.meta.test >> 8);
    hdr.INTpress[1].INTpressData = (bit<8>) (eg_md.meta.test >> 16);
    hdr.INTpress[0].INTpressData = (bit<8>) (eg_md.meta.test >> 24);
}

action set1() {
    eg_md.meta.test = eg_md.meta.test | eg_md.meta.pre_val;
    hdr.INTpress[0].INTpressData = (bit<8>) eg_md.meta.test;
}

#define PREPARE(i)\
action prepare##i##() {\
    hdr.INTpressNum.INTpressNum = hdr.INTpressNum.INTpressNum + eg_md.meta.encoding_level;\
    eg_md.meta.test = eg_md.meta.encoding_bit << (8-##i##);\
}\

PREPARE(1)
PREPARE(2)
PREPARE(3)
PREPARE(4)
PREPARE(5)
PREPARE(6)
PREPARE(7)
PREPARE(8)