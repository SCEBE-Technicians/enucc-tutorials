# Technical Specs

ENUCC has three separate partitions named: node, himem and gpu.

| Partition | Number of Nodes | Cpu                                | RAM         | 
|-----------|-----------------|------------------------------------|-------------|
| node      | 8               | AMD EPYC 7513 32-Core Processor    | 512 GB      |
| himem     | 2               | AMD EPYC 7763 64-Core Processor    | 2   TB      |
| gpu       | 4               | AMD EPYC 7543 32-Core Processor    | 2   TB      |

Each gpu node has a two NVIDIA A100 80GB PCIe GPU's

