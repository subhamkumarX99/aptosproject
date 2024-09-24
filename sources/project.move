module MyModule::TokenStaking {

    use aptos_framework::coin;
    use aptos_framework::signer;
    use aptos_framework::aptos_coin::{AptosCoin};

    struct Stake has store, key {
        staker: address,
        amount_staked: u64,
        staking_duration: u64, // Duration in days
    }

    // Function for users to stake tokens
    public fun stake_tokens(staker: &signer, amount: u64, duration: u64) {
        let stake = Stake {
            staker: signer::address_of(staker),
            amount_staked: amount,
            staking_duration: duration,
        };
        move_to(staker, stake);
    }

    // Function to distribute rewards based on staked tokens and duration
    public fun distribute_rewards(owner: &signer, staker: address, reward_rate: u64) acquires Stake {
        let stake = borrow_global<Stake>(staker);

        // Calculate rewards based on amount staked and staking duration
        let rewards = stake.amount_staked * stake.staking_duration * reward_rate / 100;

        // Transfer the rewards to the staker
        coin::transfer<AptosCoin>(owner, stake.staker, rewards);
    }
}
