# privateEthChain

This repository contains what is needed for creating a local geth node.

For creating a node follow this steps:

1. Create a directory for storing node info `mkdir Node`
2. Copy bashes to the directory `cp bashes/* Node/`
3. Enter the directory `cd Node` and run the bashes in the following order: \n
    `bash filesGen.sh` - for creating data/ logs/ and genesis.json \n
    `bash init.sh` - for initializing the blockchain with the custom sampleGenesis \n
    `bash nodeStart <RPCport> <ListeningPort>` - for running the console, <b>Note</b>: RPCport and  ListeningPort arguments are mandatory, the arguments are included if 2 nodes on same machine is desired, if so the ports must be different.

You can modify sampleGenesis if desired, however if you change networkId do not forget to change it in the nodeStart.sh

For connecting two nodes the following is required:
1. Identical genesis file hash
2. Identical networkId

If that is completed follow this steps in order to connect 2 nodes:
1. In the console of the first node type `admin.nodeInfo.enode` and copy the output, which should look like `"enode://8a23ae738eabf5ce7cba9f587aeb048178f101b1773909f9d3d71bd448e3132f32eeacd61bc022d4620d5f6e659efa304e9d28ba89c9a84a9bffd9345651b2c5@100.111.8.143:3030"`
2. In the console of the second type `admin.addPeers("enode://8a23ae738eabf5ce7cba9f587aeb048178f101b1773909f9d3d71bd448e3132f32eeacd61bc022d4620d5f6e659efa304e9d28ba89c9a84a9bffd9345651b2c5@100.111.8.143:3030")`
3. Check if the connection was established by `admin.peers` or `net.peerCount`, if there is no connected peers then disable firewall by `sudo ufw disable` and try again.

However, the connection is lost after geth restart. If you want two nodes to be always connected on boot, then create a file `static-nodes.json` in `data/geth/` and paste the following: \n
`[
"enode://8a23ae738eabf5ce7cba9f587aeb048178f101b1773909f9d3d71bd448e3132f32eeacd61bc022d4620d5f6e659efa304e9d28ba89c9a84a9bffd9345651b2c5@100.111.8.143:3030"
]`
