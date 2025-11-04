
#############################################################
###################### How to use ###########################
#############################################################

# $SDE/run_bfshell.sh -f bfrt_rule_INTpress.py

#############################################################
######################## Library ############################
#############################################################

import pandas as pd

#############################################################
################### Ingress Section #########################
#############################################################

p4_ingress = bfrt.INTpress.pipe.SwitchIngress

tb_set_source = p4_ingress.tb_set_source
tb_set_source.add_with_int_set_source(
    # hdr.ipv4.dscp : exact;
    dscp=0x3
)
print("tb_set_source: Set source rule inserted!")

tb_set_switch_id = p4_ingress.tb_set_switch_id
tb_set_switch_id.add_with_set_switch_id(
    # 65x2 : 1, 65x : 2, 32x : 3
    # hdr.ipv4.version: exact;
    version = 4,
    switch_id = 1
)
print("tb_set_switch_id: Set switch ID rule inserted!")

tb_forward = p4_ingress.tb_forward
tb_forward.add_with_set_egress_port(
    # ig_intr_md.ingress_port: exact;
    ingress_port = 0,

    port = 1
)
print("tb_forward: Forwarding rule inserted!")

#############################################################
#################### Egress Section #########################
#############################################################

df = pd.read_csv('/home/mncgpu5/chanbin/INTpress/p4src/Tofino/rule/CompressionRules.csv')
code_length = df['code_length'].tolist() if 'cloud_length' in df.columns else []
code = df['code'].tolist() if 'code' in df.columns else []
count = df['count'].tolist() if 'count' in df.columns else []
value = df['value'].tolist() if 'value' in df.columns else []
section_size = df['section_size'].tolist() if 'section_size' in df.columns else []

p4_egress = bfrt.INTpress.pipe.SwitchEgress

for i in range(len(code_length)):
    if count[i] == 0:
        func1 = f"p4_egress.tb_encoding_queue1.add_with_encoding_queue1(" + \
            f"queue_shift1 = {value[i]}," + \
            f"encoding_level = 32,"+ \
            f"encoding_bit = {bin(code[i])})"
        exec(func1)
    elif section_size[i] == 1: 
        func1 = f"p4_egress.tb_encoding_queue1.add_with_encoding_queue1(" + \
            f"queue_shift1 = {value[i]}," + \
            f"encoding_level = {code_length[i]},"+ \
            f"encoding_bit = 0b{code[i]})"
        exec(func1)
    elif section_size[i] == 2:
        func1 = f"p4_egress.tb_encoding_queue1.add_with_encoding_queue1(" + \
            f"queue_shift1 = {value[i]}," + \
            f"encoding_level = {code_length[i]},"+ \
            f"encoding_bit = 0b{code[i]})"
        exec(func1)
    elif section_size[i] == 4:
        func1 = f"p4_egress.tb_encoding_queue2.add_with_encoding_queue2(" + \
            f"queue_shift1 = {value[i]}," + \
            f"encoding_level = {code_length[i]},"+ \
            f"encoding_bit = 0b{code[i]})"
        exec(func1)
    elif section_size[i] == 8:
        func1 = f"p4_egress.tb_encoding_queue2.add_with_encoding_queue2(" + \
            f"queue_shift1 = {value[i]}," + \
            f"encoding_level = {code_length[i]},"+ \
            f"encoding_bit = 0b{code[i]})"
        exec(func1)
    elif section_size[i] == 16:
        func1 = f"p4_egress.tb_encoding_queue2.add_with_encoding_queue2(" + \
            f"queue_shift1 = {value[i]}," + \
            f"encoding_level = {code_length[i]},"+ \
            f"encoding_bit = 0b{code[i]})"
        exec(func1)
print("tb_encoding_queue1 and tb_encoding_queue2: Encoding rules inserted!")

tb_update_space = p4_egress.tb_update_space
for delta in range(0,8):
    for level in range(1,25):
        if delta == 0 and 1<= level <= 8:
            func1 = f"p4_egress.tb_update_space.add_with_update_space_0(" + \
                    f"delta = {delta}," + \
                    f"encoding_level = {level})"
            exec(func1)
        elif delta == 0 and 9 <= level <= 16:
            func1 = f"p4_egress.tb_update_space.add_with_update_space_0(" + \
                    f"delta = {delta}," + \
                    f"encoding_level = {level})"
            exec(func1)
        elif delta == 0 and 17 <= level <= 24:
            func1 = f"p4_egress.tb_update_space.add_with_update_space_0(" + \
                    f"delta = {delta}," + \
                    f"encoding_level = {level})"
            exec(func1)
        elif (delta >= level) and (delta + level) <= 8:
            func1 = f"p4_egress.tb_update_space.add_with_set1(" + \
                    f"delta = {delta}," + \
                    f"encoding_level = {level})"
            exec(func1)
        elif (delta < level) and (delta + level) <= 16:
            func1 = f"p4_egress.tb_update_space.add_with_update_space_1(" + \
                    f"delta = {delta}," + \
                    f"encoding_level = {level})"
            exec(func1)
        elif (delta < level) and(delta + level) <= 24:
            func1 = f"p4_egress.tb_update_space.add_with_update_space_2(" + \
                    f"delta = {delta}," + \
                    f"encoding_level = {level})"
            exec(func1)
        elif (delta < level) and (delta + level) <= 32:
            func1 = f"p4_egress.tb_update_space.add_with_update_space_3(" + \
                    f"delta = {delta}," + \
                    f"encoding_level = {level})"
            exec(func1)
        print(f'Delta = {delta} case inserted!')
print("tb_update_space_hop: Space update rule inserted!") 

tb_prepare = p4_egress.tb_prepare
tb_prepare.add_with_prepare1(
    # eg_md.meta.delta: exact;
    delta = 1
)
tb_prepare.add_with_prepare2(
    # eg_md.meta.delta: exact;
    delta = 2
)
tb_prepare.add_with_prepare3(
    # eg_md.meta.delta: exact;
    delta = 3
)
tb_prepare.add_with_prepare4(
    # eg_md.meta.delta: exact;
    delta = 4
)
tb_prepare.add_with_prepare5(
    # eg_md.meta.delta: exact;
    delta = 5
)
tb_prepare.add_with_prepare6(
    # eg_md.meta.delta: exact;
    delta = 6
)
tb_prepare.add_with_prepare7(
    # eg_md.meta.delta: exact;
    delta = 7
)
tb_prepare.add_with_prepare8(
    # eg_md.meta.delta: exact;
    delta = 0
)
print("tb_prepare: Bit shift rule inserted!") 