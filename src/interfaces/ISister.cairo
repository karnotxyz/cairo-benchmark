#[starknet::interface]
pub trait ISister<TContractState> {
    fn call_me_back(self: @TContractState);
}

