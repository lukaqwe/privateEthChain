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
    `bash nodeStart <NetworkID> <RPCport> <ListeningPort>` - for running the console, <b>Note</b>: NetworkID, RPCport and  ListeningPort arguments are mandatory, the arguments are included if 2 nodes on same machine is desired, if so the ports must be different. You can set them by modifying the bash with your desired values by replacing them instead of $1, $2, $3.

You can modify sampleGenesis if desired, however if you change networkId do not forget to change it in nodeStart.sh

Create an account and mine some ether so that your account has some balance for contract deployment.

Account creation:

>       personal.newAccount(<password>)

Start mining:

>       miner.start()

Stop mining:

>       miner.stop()

Check balance:

>       eth.getBalance(eth.coinbase)

You also can connect ethereum wallet to this private network for playing around. You can do so only when your geth instance is running. Go in `data/` folder of your node directory and type `ethereumwallet --rpc geth.ipc`.

Connecting 2 nodes
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

 <h3>1. Remix IDE </h3>

It is the easiest way to deploy a contract since you have a graphical interface and the IDE does everything what's behind for you. Create a file and paste your contract code there. Compile it. And when to run, choose the `Web3 provider` Environment. In the popping window replace `:8545` with the port you provided as an argument to `--rpcport` when instantiating the geth console. In my case `8540` if I want to connect to `Node0`, or `8541` if I want to connect to `Node 1`. If you didn't specify and argument to `--rpcport` then leave `8545` which is the default geth port. Press OK. If successful you should have your networkID near `Web3 Provider` box. If you get an error try the same in another browser (Chrome is the most compatible one). To interact with the contract just get dazzled by the magical properties of buttons.

 <h3>2. Truffle </h3>

The most convenient and most advised way to deploy a contract is using the <a href="https://www.trufflesuite.com/"> truffle framework </a>. Very useful for development purposes since it gives possibilities Remix can't and at the same time provides simplicity.
For using the framework you first need to install it by `npm install -g truffle`. Also you must have the solidity compiler installed, you can do this by `sudo apt install solc`. Then you have to make a project directory, go in it, then type `truffle init`. After download you should have the following folder structure: <br>

<ul>
 <li>contracts/ - directory where truffle expects to find contracts</li>
 <li>migrations/ - folder to place scriptable deployment files</li>
 <li>test/ - location of test files</li>
 <li>truffle-config.js - configuration file </li>
</ul>  

<br> Set your configuration file like this:

>       module.exports = {
>       networks: {
>         development: {
>           host: '127.0.0.1',
>           port: <your rpc port number>,
>           network_id: '<your network ID>'
>         }
>       }
>     }

<br>
Though, you can configure the file to connect to the network you want, you can find more information <a href = "truffleframework.com/docs/advanced/configuration"> here </a> or in the `truffle-config.js` file comments.

Create your contract file in the folder contracts/ . Then create a migration file with the name `2_deploy_contract.js` (you can name it whatever you want but it should start with 2_ so truffle can differentiate the migration files) and paste the content of `1_initial_migration.js` in it, replace the word `Migrations` with your contract name. Eventually the migration file should look something like this : <br>

>     var MyContract = artifacts.require("MyContract");
>     
>     module.exports = function(deployer) {
>      deployer.deploy(MyContract);
>      }


 <br> If your contract's  constructor requires arguments then declare the deployer like this `deployer.deploy(MyContract, arg1, arg2, ...)`. For more information on deployment options check <a href="https://www.trufflesuite.com/docs/truffle/getting-started/running-migrations"> migrations documentation </a>. (You know what, you can actually check all the <a href = "https://www.trufflesuite.com/docs/truffle/overview"> truffle documentation </a>). <br>

After you've done the migration file, type `truffle compile` then `truffle migrate` while being in the project directory. If you already migrated your contract but you want to reset it use `truffle migrate --reset`. Be sure you unlocked your account before running `truffle migrate` and that miner is on. If you get transaction details as an output as well as contract address then, voilà, your contract is deployed. You can interact with the contract in the truffle console. First you need truffle-contract package, install by `sudo npm install -g @truffle/contract`. You can create a contract instance by `let instance = await myContract.deployed()` then you can call its functions. Also you can create an instance asynchronously with `myContract.deployed().then(function (result){instance = result})`. You can also create a new contract once you have it compiled by `let newInstance = await myContract.new([arg1,arg2,...])` or `myContract.new([arg1,arg2,...]).then(function(result){newInstance = result})`. More <a href = "https://www.trufflesuite.com/docs/truffle/getting-started/interacting-with-your-contracts"> here</a> or  <a href = "https://github.com/trufflesuite/truffle/tree/master/packages/contract"> here </a>.

<h3>3. Geth </h3>

Deploying and interacting with smart contracts in geth is cumbersome. It is not simple since there are not tools that do the work for you, but by using geth you can learn what is going on behind. For deployment you need just 2 lines of code. Before applying them you need the contract's abi and its bytecode. You can  get the ABI by `solc --abi myContract.sol` abd the  bytecode with `solc --bin myContract.sol`. <br> Then declare the contract by `var contract = eth.contract(<your-abi-here>)`, and  instantiate by  `var contractInstance = contract.new([arg1,...],{from: eth.accounts[0] , data: '0x<your-bin-here>', gas : 12345678})`, where `[arg1, ...]` are constructor arguments. After mining the contract it should be deployed and you can interact with it by calling its functions using `.call()` or `.sendTransaction(<transaction-json>)`. If your contract was not mined then increase the gas value, if then the contract is not mined then you should check if your constructor has no problems being called. When interacting with your smart contract `call()` is used when the state is not changed, while `sendTransaction()` is used when the state of the contract is changed, therefore for the return the transaction must be mined. You can call them in multiple ways but be sure before doing that to set a default account, ex : `eth.defaultAccount = eth.coinbase `, doing otherwise will get you the error <i>invalid address</i>. After function call you may also get the error <i> gas required exceeds allowance or always failing transaction</i>. This is because the contract execution requires more gas than the current gas limit. The gas limit is set at the genesis block and is updated after each block if it is reached, you can see the value with which it is updated in the <a href = "https://ethereum.github.io/yellowpaper/paper.pdf"> Ethereum Yellow Paper </a>. To see how much gas the call requires you can do the following:   

>     var callData = contractInstance.method.getData([arg1,...])
>     eth.estimateGas({from : eth.defaultAccount, to : contractInstance.address , data : callData})

For setting a new gas limit, you need to call the geth instance again with `--targetgaslimit <some-good-big-number>` along with the other arguments. Setting this number too big might be risky if you are not careful how network's computational resources are used. If, however, after setting the new gas limit you still can't run your contract, or even you can't get the gas estimate because of the same error, then you should look at the nature of your contract. There might be some functions whose gas requirement is infinite. For seeing if there are such, compile your contract in Remix IDE, and look at the warnings in Solidity Static Analysis. A function requires infinite gas if it has some variable with non-fixed length or an infinite loop.

Non-changeable methods can be called in the following ways:

>     contractInstance.method([arg1, ...])  
>     contractInstance.method.call([arg1, ...])
>     contractInstance.method([arg1,...]).call()

Changeable methods can be called in the following ways:

>     contractInstance.method([arg1,...]).sendTransaction({from: <address>})
>     contractInstance.method.sendTransaction([arg1, ...], {from : <address>})

Where  `[arg1, ...]` are method's arguments.


More at https://github.com/ethereum/go-ethereum/wiki/Contract-Tutorial.
