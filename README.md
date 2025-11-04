# INTpress

<p align="center">
<img src="graphs/INTpress_thumbnail.png" alt="INTpress Overview" width="800">
  
Although in-band network telemetry (INT) allows for real-time and fine-grained network monitoring through a programmable data plane, it also adds to bandwidth overhead due to embedding network details in the packet headers. To mitigate this overhead, a compression technique can be used; yet, applying such compression in the data plane poses another challenge, as it may surpass available hardware resources. To tackle this, we introduce a compression-based quantized INT (INTpress), designed to efficiently decrease overhead by encoding data into shorter bit lengths in a manner native to the data plane. We also develop a dynamic data partition algorithm that formulates compression rules balancing monitoring accuracy and bandwidth usage. We implemented the INTpress switch using Tofino programmable switches, facilitating serialization to adeptly manage variable-length compressed bit streams, thus significantly cutting down bandwidth usage. 

# Performance Results

## BMv2 environments
### Data center networks
<p align="center">
<table>
  <tr>
    <td align="center"><img src="graphs/RBU/result_ft_queue_RBU.png" width="210"/></td>
    <td align="center"><img src="graphs/RMSE/result_ft_queue_RMSE.png" width="210"/></td>
  </tr>
  <tr>
    <td align="center">RBU of queue</td>
    <td align="center">RMSE of hop queue</td>
  </tr>
</table>

### Backbone Network
<p align="center">
<table>
  <tr>
    <td align="center"><img src="graphs/RBU/result_i_queue_RBU.png" width="210"/></td>
    <td align="center"><img src="graphs/RMSE/result_i_queue_RMSE.png" width="210"/></td>
  </tr>
  <tr>
    <td align="center">RBU of queue</td>
    <td align="center">RMSE of hop queue</td>
  </tr>
</table>

### Mobile core networks
<p align="center">
<table>
  <tr>
    <td align="center"><img src="graphs/RBU/result_mcn_queue_RBU.png" width="210"/></td>
    <td align="center"><img src="graphs/RMSE/result_mcn_queue_RMSE.png" width="210"/></td>
  </tr>
  <tr>
    <td align="center">RBU of queue</td>
    <td align="center">RMSE of hop queue</td>
  </tr>
</table>

## Tofino environments
### Topology
This is the topology used during the performance evaluation of INTpress on the Tofino:
<img src="graphs/Tofino_topology.png" widt="800"/>
Traffic was generated with DPDK and sent by host1 towards host2, with each switch running the INTpress pipeline.

### Performances
<p align="center">
<table>
  <tr>
    <td align="center"><img src="graphs/RBU/result_t_queue_RBU.png" width="210"/></td>
    <td align="center"><img src="graphs/RMSE/result_t_queue_RMSE.png" width="210"/></td>
  </tr>
  <tr>
    <td align="center">RBU of queue</td>
    <td align="center">RMSE of hop queue</td>
  </tr>
</table>
