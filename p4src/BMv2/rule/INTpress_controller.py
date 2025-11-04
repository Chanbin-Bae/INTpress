from p4utils.utils.sswitch_thrift_API import *
import pandas as pd

def read_rules():
    global code_length, code, count, value, section_size
    df = pd.read_csv('~/INTpress/p4src/Tofino/rule/CompressionRules.csv')
    code_length = df['code_length'].tolist() if 'code_length' in df.columns else []
    code = df['code'].tolist() if 'code' in df.columns else []
    count = df['count'].tolist() if 'count' in df.columns else []
    value = df['value'].tolist() if 'value' in df.columns else []
    section_size = df['section_size'].tolist() if 'section_size' in df.columns else []

class Controller(object):

###############################################################################################
##########                                 Ingress                                   ##########
###############################################################################################

    def __init__(self):
        self.controller_sw1 = SimpleSwitchThriftAPI(9090)
        self.controller_sw2 = SimpleSwitchThriftAPI(9091)
        self.controller_sw3 = SimpleSwitchThriftAPI(9092)

    def set_source_node(self):
        self.controller_sw1.table_add("tb_set_source",
                                      "int_set_source",
                                      ['0x3'],
                                      )
    
    def set_switch_id(self):
        self.controller_sw1.table_add("tb_set_switch_id",
                                      "set_switch_id",
                                      ['4'],
                                      ['1'])
        self.controller_sw2.table_add("tb_set_switch_id",
                                      "set_switch_id",
                                      ['4'],
                                      ['2'])
        self.controller_sw3.table_add("tb_set_switch_id",
                                      "set_switch_id",
                                      ['4'],
                                      ['3'])

        
    def routing_table(self):
        self.controller_sw1.table_add("tb_forward",
                                      "set_egress_port",
                                      ['1'],
                                      ['2'])
        self.controller_sw2.table_add("tb_forward",
                                      "set_egress_port",
                                      ['1'],
                                      ['2'])
        self.controller_sw3.table_add("tb_forward",
                                      "set_egress_port",
                                      ['2'],
                                      ['1'])
    
################################################################################################
##########                                  Egress                                    ##########
################################################################################################

    def CopmressRule(self):
        global code_length, code, count, value, section_size
        # 1 / 2
        for i in range(len(code_length)):
            if count[i] == 0:
                self.controller.sw1.table_add("tb_encoding_queue1",
                                              "encoding_queue1",
                                              [str(code_length[i])],
                                              [str(code[i])]
                                              )
                self.controller.sw2.table_add("tb_encoding_queue1",
                                              "encoding_queue1",
                                              [str(code_length[i])],
                                              [str(code[i])]
                                              )
                self.controller.sw3.table_add("tb_encoding_queue1",
                                              "encoding_queue1",
                                              [str(code_length[i])],
                                              [str(code[i])]
                                              )
            elif section_size[i] == 1:
                self.controller.sw1.table_add("tb_encoding_queue1",
                                              "encoding_queue1",
                                              [str(code_length[i])],
                                              [str(code[i])]
                                              )
                self.controller.sw2.table_add("tb_encoding_queue1",
                                              "encoding_queue1",
                                              [str(code_length[i])],
                                              [str(code[i])]
                                              )
                self.controller.sw3.table_add("tb_encoding_queue1",
                                              "encoding_queue1",
                                              [str(code_length[i])],
                                              [str(code[i])]
                                              )
            elif section_size[i] == 2:
                self.controller.sw1.table_add("tb_encoding_queue1",
                                              "encoding_queue1",
                                              [str(code_length[i])],
                                              [str(code[i])]
                                              )
                self.controller.sw2.table_add("tb_encoding_queue1",
                                              "encoding_queue1",
                                              [str(code_length[i])],
                                              [str(code[i])]
                                              )
                self.controller.sw3.table_add("tb_encoding_queue1",
                                              "encoding_queue1",
                                              [str(code_length[i])],
                                              [str(code[i])]
                                              )
            else:
                self.controller.sw1.table_add("tb_encoding_queue3",
                                              "encoding_queue3",
                                              [str(code_length[i])],
                                              [str(code[i])]
                                              )
                self.controller.sw2.table_add("tb_encoding_queue3",
                                              "encoding_queue3",
                                              [str(code_length[i])],
                                              [str(code[i])]
                                              )
                self.controller.sw3.table_add("tb_encoding_queue3",
                                              "encoding_queue3",
                                              [str(code_length[i])],
                                              [str(code[i])]
                                              )
    

    def update_space(self):
        global code_length
        for delta in range(0,8):
            for level in range(1,11):
                if delta == 0 and 1<= level <= 8:
                    self.controller.sw1.table_add("tb_update_space_0",
                                                  "update_space_0",
                                                  [str(delta), str(level)],
                                                  )
                    self.controller.sw2.table_add("tb_update_space_0",
                                                  "update_space_0",
                                                  [str(delta), str(level)],
                                                  )
                    self.controller.sw3.table_add("tb_update_space_0",
                                                  "update_space_0",
                                                  [str(delta), str(level)],
                                                  )
                elif delta == 0 and 9 <= level <= 16:
                    self.controller.sw1.table_add("tb_update_space_0",
                                                  "update_space_0",
                                                  [str(delta), str(level)],
                                                  )
                    self.controller.sw2.table_add("tb_update_space_0",
                                                  "update_space_0",
                                                  [str(delta), str(level)],
                                                  )
                    self.controller.sw3.table_add("tb_update_space_0",
                                                  "update_space_0",
                                                  [str(delta), str(level)],
                                                  )                    
                elif (delta >= level) and (delta + level) <= 8:
                    self.controller.sw1.table_add("tb_update_space_1",
                                                  "update_space_1",
                                                  [str(delta), str(level)],
                                                  )
                    self.controller.sw2.table_add("tb_update_space_1",
                                                  "update_space_1",
                                                  [str(delta), str(level)],
                                                  )
                    self.controller.sw3.table_add("tb_update_space_1",
                                                  "update_space_1",
                                                  [str(delta), str(level)],
                                                  )
                elif (delta < level) and (delta + level) <= 16:
                    self.controller.sw1.table_add("tb_update_space_1",
                                                  "update_space_1",
                                                  [str(delta), str(level)],
                                                  )
                    self.controller.sw2.table_add("tb_update_space_1",
                                                  "update_space_1",
                                                  [str(delta), str(level)],
                                                  )
                    self.controller.sw3.table_add("tb_update_space_1",
                                                  "update_space_1",
                                                  [str(delta), str(level)],
                                                  )
                elif (delta < level) and (delta + level) <= 24:
                    self.controller.sw1.table_add("tb_update_space_2",
                                                  "update_space_3",
                                                  [str(delta), str(level)],
                                                  )
                    self.controller.sw2.table_add("tb_update_space_2",
                                                  "update_space_2",
                                                  [str(delta), str(level)],
                                                  )
                    self.controller.sw3.table_add("tb_update_space_2",
                                                  "update_space_2",
                                                  [str(delta), str(level)],
                                                  )

    
        

        

################################################################################################
##########                                    Main                                    ##########
################################################################################################

if __name__ == "__main__":
    global code_length, code, count, value, section_size
    read_rules()

    controller = Controller()

    controller.set_source_node()
    controller.set_switch_id()
    controller.routing_table()
    controller.CopmressRule()
    controller.update_space()
