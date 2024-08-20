use starknet::ContractAddress;
#[starknet::interface]
pub trait IBenchmark<TContractState> {
    fn hash_recursively(ref self: TContractState, data: Array<u8>, loop_count: u256) -> Array<u8>;
    fn create_inventories(ref self: TContractState, loop_count: u256);
    fn update_inventories(ref self: TContractState, loop_count: u256);
    fn nested_contract_call(
        ref self: TContractState, sister_contract_address: ContractAddress, loop_count: u256
    );
    fn reply(ref self: TContractState, sister_contract_address: ContractAddress);
    fn do_all(ref self: TContractState, loop_count: u256);
}

