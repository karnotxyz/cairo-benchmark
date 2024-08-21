
#### Adding accounts
- Run this command to add an account, or add an account and add it as profile in the `snfoundry.toml`
```shell
sncast --url "https://starknet-sepolia.public.blastapi.io/rpc/v0_7" account add --name braavosDev --address <ADDRESS> --private-key <PRIVATE_KEY> --type braavos --add-profile development
```


#### List Accounts
```shell
sncast --url "https://starknet-sepolia.public.blastapi.io/rpc/v0_7" account list
```

To list with the private keys, run the following
```shell
sncast --url "https://starknet-sepolia.public.blastapi.io/rpc/v0_7" account list -p
```

#### Deleting accounts
```shell
 sncast --url "https://starknet-sepolia.public.blastapi.io/rpc/v0_7" account delete --name braavosDev
```

## Deploying the contracts
Make sure you have already added an account as profile first in the `snfoundry.toml`
```shell
make deploy
```



