#[starknet::contract]
mod BenchmarkContract {
    use core::serde::Serde;
    use core::option::OptionTrait;
    use core::traits::Into;
    use core::clone::Clone;
    use alexandria_math::sha256::sha256;
    use benchmark_tests::interfaces::{
        IBenchmark::IBenchmark, ISister::{ISister, ISisterDispatcher, ISisterDispatcherTrait}
    };

    #[derive(Drop, Serde, Clone, starknet::Store)]
    struct Article {
        id: felt252,
        name: felt252,
        quantity: u32,
        attributes: ArticleAttributes,
    }

    #[derive(Drop, Serde, Clone, starknet::Store)]
    struct ArticleAttributes {
        durability: u8,
        weight: u16,
    }

    #[derive(Drop, Serde, Clone, starknet::Store)]
    struct Inventory {
        owner: ContractAddress,
        capacity: u256,
        stats: InventoryStats,
    }

    #[derive(Drop, Serde, Clone, starknet::Store)]
    struct InventoryStats {
        total_items: u256,
        total_weight: u256,
        rarest_item: Article,
        last_updated: u64,
    }
    use starknet::get_caller_address;
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        inventories: LegacyMap::<u256, Inventory>,
        depth: u256
    }


    #[abi(embed_v0)]
    impl BenchmarkImpl of IBenchmark<ContractState> {
        fn hash_recursively(
            ref self: ContractState, data: Array<u8>, loop_count: u256
        ) -> Array<u8> {
            let mut index = 0;
            let mut hashed_data = data;
            while index < loop_count {
                let hash = sha256(hashed_data.clone());

                hashed_data = hash;
                index = index + 1;
            };

            return hashed_data;
        }


        // @dev: This functions makes multiple storage writes in loop withoutt making any reads
        fn create_inventories(ref self: ContractState, loop_count: u256) {
            let mut index = 0;
            while index < loop_count {
                index += 1;

                let new_inventory = Inventory {
                    owner: get_caller_address(),
                    capacity: index,
                    stats: InventoryStats {
                        total_items: index,
                        total_weight: index,
                        rarest_item: Article {
                            id: index.try_into().unwrap(),
                            name: index.try_into().unwrap(),
                            quantity: index.try_into().unwrap(),
                            attributes: ArticleAttributes {
                                durability: index.try_into().unwrap(),
                                weight: index.try_into().unwrap()
                            }
                        },
                        last_updated: starknet::get_block_timestamp(),
                    }
                };
                self.inventories.write(index, new_inventory);
            }
        }


        // @dev: This performs a multiple reads and writes on storage in a loop 
        fn update_inventories(ref self: ContractState, loop_count: u256) {
            let mut index = 0;
            while index < loop_count {
                index += 1;

                let old_inventory = self.inventories.read(index);

                let new_inventory = Inventory {
                    stats: InventoryStats {
                        last_updated: starknet::get_block_timestamp(), ..old_inventory.clone().stats
                    },
                    ..old_inventory
                };
                self.inventories.write(index, new_inventory);
            }
        }

        fn nested_contract_call(
            ref self: ContractState, sister_contract_address: ContractAddress, loop_count: u256
        ) {
            self.depth.write(loop_count);
            self.reply(sister_contract_address);
        }

        fn reply(ref self: ContractState, sister_contract_address: ContractAddress) {
            let current_depth = self.depth.read();
            if (current_depth == 0) {
                return;
            }
            self.depth.write(current_depth - 1);

            let sister_dispatcher = ISisterDispatcher { contract_address: sister_contract_address };
            sister_dispatcher.call_me_back();
        }

        fn do_all(ref self: ContractState, loop_count: u256) {
            let mut data = array!['h', 'a', 's', 'h', 't', 'h', 'i', 's', 'd', 'a', 't', 'a'];
            self.hash_recursively(data, loop_count);
            self.create_inventories(loop_count);
            self.update_inventories(loop_count);
        }
    }
}
