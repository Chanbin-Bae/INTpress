/**********************************************************
********************* Egress Action ***********************
**********************************************************/

action bit_shift(){
    meta.queue_occupancy_shift1 = meta.queue_occupancy >> 2;//2
    meta.queue_occupancy_shift3 = meta.queue_occupancy >> 4;//8
}

action encoding_queue1(bit<8> encoding_level, bit<32> encoding_bit){
    meta.encoding_level = encoding_level;
    meta.encoding_bit = encoding_bit;
}

action encoding_queue3(bit<8> encoding_level, bit<32> encoding_bit){
    meta.encoding_level = encoding_level;
    meta.encoding_bit = encoding_bit;
}

action update_space_0() {
    hdr.INTpressSpace.INTpressSpace = hdr.INTpressSpace.INTpressSpace + 8;
    hdr.INTpress.push_front(1);
    hdr.INTpress[0].setValid();

    hdr.INTpress[0].INTpressData = (bit<8>) (meta.test);
}

action update_space_1() {
    hdr.INTpressSpace.INTpressSpace = hdr.INTpressSpace.INTpressSpace + 8;
    hdr.INTpress.push_front(1);
    hdr.INTpress[0].setValid();

    meta.test = meta.test | meta.pre_val;
    hdr.INTpress[1].INTpressData = (bit<8>) (meta.test);
    hdr.INTpress[0].INTpressData = (bit<8>) (meta.test >> 8);
}

action update_space_2() {
    hdr.INTpressSpace.INTpressSpace = hdr.INTpressSpace.INTpressSpace + 16;
    hdr.INTpress.push_front(2);
    hdr.INTpress[0].setValid();
    hdr.INTpress[1].setValid();

    meta.test = meta.test | meta.pre_val;
    hdr.INTpress[2].INTpressData = (bit<8>) meta.test;
    hdr.INTpress[1].INTpressData = (bit<8>) (meta.test >> 8);
    hdr.INTpress[0].INTpressData = (bit<8>) (meta.test >> 16);
}

action update_space_3() {
    hdr.INTpressSpace.INTpressSpace = hdr.INTpressSpace.INTpressSpace + 24;
    hdr.INTpress.push_front(3);
    hdr.INTpress[0].setValid();
    hdr.INTpress[1].setValid();
    hdr.INTpress[2].setValid();

    meta.test = meta.test | meta.pre_val;
    hdr.INTpress[3].INTpressData = (bit<8>) meta.test;
    hdr.INTpress[2].INTpressData = (bit<8>) (meta.test >> 8);
    hdr.INTpress[1].INTpressData = (bit<8>) (meta.test >> 16);
    hdr.INTpress[0].INTpressData = (bit<8>) (meta.test >> 24);
}

action set1() {
    meta.test = meta.test | meta.pre_val;
    hdr.INTpress[0].INTpressData = (bit<8>) meta.test;
}

#define PREPARE(i)\
action prepare##i##() {\
    hdr.INTpressNum.INTpressNum = hdr.INTpressNum.INTpressNum + meta.encoding_level;\
    meta.test = meta.encoding_bit << (8-##i##);\
}\

PREPARE(1)
PREPARE(2)
PREPARE(3)
PREPARE(4)
PREPARE(5)
PREPARE(6)
PREPARE(7)
PREPARE(8)