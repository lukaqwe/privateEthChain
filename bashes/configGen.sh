geth --ethash.dagdir=./dag/ --datadir=./data/ --networkid $1 --rpc --rpcport $2 --port $3 --ipcpath=./data/geth.ipc --rpccorsdomain "*" --rpcapi admin,eth,web3,personal,net dumpconfig config.toml
