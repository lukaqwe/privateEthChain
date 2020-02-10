# privateEthChain


This repository contains what is needed for creating a local geth node and deploying a contract on it.

Node Creation
---
For creating a node follow this steps:

1. Create a directory for storing node info `mkdir Node`
2. Copy bashes to the directory `cp bashes/* Node/`
3. Enter the directory `cd Node` and run the bashes in the following order: <br>
    `bash filesGen.sh` - for creating data/ logs/ and genesis.json <br>
    `bash init.sh` - for initializing the blockchain with the custom sampleGenesis <br>
    `bash nodeStart <RPCport> <ListeningPort>` - for running the console, <b>Note</b>: RPCport and  ListeningPort arguments are mandatory, the arguments are included if 2 nodes on same machine is desired, if so the ports must be different.

You can modify sampleGenesis if desired, however if you change networkId do not forget to change it in the nodeStart.sh

Connecting 2 nodeStart
---
For connecting two nodes the following is required:
1. Identical genesis file hash
2. Identical networkId

If that is completed follow this steps in order to connect 2 nodes:
1. In the console of the first node type `admin.nodeInfo.enode` and copy the output, which should look like `"enode://8a23ae738eabf5ce7cba9f587aeb048178f101b1773909f9d3d71bd448e3132f32eeacd61bc022d4620d5f6e659efa304e9d28ba89c9a84a9bffd9345651b2c5@100.111.8.143:3030"`
2. In the console of the second type `admin.addPeers("enode://8a23ae738eabf5ce7cba9f587aeb048178f101b1773909f9d3d71bd448e3132f32eeacd61bc022d4620d5f6e659efa304e9d28ba89c9a84a9bffd9345651b2c5@100.111.8.143:3030")`
3. Check if the connection was established by `admin.peers` or `net.peerCount`, if there is no connected peers then disable firewall by `sudo ufw disable` and try again.

However, the connection is lost after geth restart. If you want two nodes to be always connected on boot, then create a file `static-nodes.json` in `data/geth/` and paste the enode configuration of the other node, like the following: <br>
`[
"enode://8a23ae738eabf5ce7cba9f587aeb048178f101b1773909f9d3d71bd448e3132f32eeacd61bc022d4620d5f6e659efa304e9d28ba89c9a84a9bffd9345651b2c5@100.111.8.143:3030"
]`

Contract Deployment
---
There are multiple ways in which you can deploy a contract, each with its itricacies and requirements. Here are displayed 3 ways of deploying a contract, using: Remix IDE, truffle framework, geth. <br>

1. <h3>Remix IDE </h3> <br>

It is the easiest way to deploy a contract since you have a graphical interface and the IDE does everything what's behind for you. Create a file and paste your contract code there. Compile it. And when to run, choose the `Web3 provider` Environment. In the popping window replace `:8545` with the port you provided as an argument to `--rpc` when instantiating the geth console. In my case `8585` if I want to connect to `Node0`, or `8540` if I want to connect to `Node 1`. If you didn't specify and argument to `--rpc` then leave `8545` which is the default geth port. Press OK. If successful you should have your networkID near `Web3 Provider` box. If you get an error try the same in another browser (Chrome is the most compatible one). To interact with the contract just get dazzled by the magical properties of buttons.

2. <h3> Truffle </h3> <br>

The most convenient and most advised way to deploy a contract is using the <a href="https://www.trufflesuite.com/"> framework </a>. Very useful for development purposes since it gives possibilities Remix can't and at the same time provides simplicity.
For using the framework you first need to install it by `npm install -g truffle`. Also you must have the solidity compiler installed, you can do this by `sudo apt install solc`. Then you have to make a project directory, go in it, then type `truffle init`. After download you should have the following folder structure: <br>

<ul>
 <li>contracts/ - directory where truffle expects to find contracts</li>
 <li>migrations/ - folder to place scriptable deployment files</li>
 <li>test/ - location of test files</li>
 <li>truffle-config.js - configuration file </li>
</ul>  

<br> Set your configuration file like this:

`>       module.exports = {
>       networks: {
>         development: {
>           host: '127.0.0.1',
>           port: <your rpc port number>,
>           network_id: '<your network ID>'
>         }
>       }
>     }
`
<br>
Though, you can configure the file to connect to the network you want, you can find more information <a href = "truffleframework.com/docs/advanced/configuration"> here </a> or in the `truffle-config.js` file comments.

Create your contract file in the folder contracts/ . Then create a migration file with the name `2_deploy_contract.js` (you can name it whatever you want but it should start with 2_ so truffle can differentiate the migration files) and paste the content of `1_initial_migration.js` in it, replace the word `Migrations` with your contract name. Eventually the migration file should look something like this : <br>
`>     var MyContract = artifacts.require("MyContract");
>     
>     module.exports = function(deployer) {
      deployer.deploy(MyContract);
      }
` <br> If your contract's  constructor requires arguments then declare the deployer like this `deployer.deploy(MyContract, arg1, arg2, ...)`. For more information on deployment options check <a href="https://www.trufflesuite.com/docs/truffle/getting-started/running-migrations"> migrations documentation </a>. (You know what, you can actually check all the <a href = "https://www.trufflesuite.com/docs/truffle/overview"> truffle documentation </a>). <br>

After you've done the migration file, type `truffle compile` then `truffle migrate` while being in the project directory. If you already migrated your contract but you want to reset it use `truffle migrate --reset`. 
