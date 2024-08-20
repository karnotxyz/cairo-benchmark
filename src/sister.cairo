#[starknet::contract]
mod SisterContract {
    use starknet::{get_caller_address, get_contract_address};
    #[storage]
    struct Storage {}

    use benchmark_tests::interfaces::{
        IBenchmark::{IBenchmark, IBenchmarkDispatcher, IBenchmarkDispatcherTrait}, ISister::ISister
    };

    #[abi(embed_v0)]
    impl SisterImpl of ISister<ContractState> {
        fn call_me_back(self: @ContractState) {
            let caller = get_caller_address();
            let benchmark_dispatcher = IBenchmarkDispatcher { contract_address: caller };
            benchmark_dispatcher.reply(get_contract_address());
        }
    }
}

