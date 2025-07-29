module 0x1::basic_coin {
    use std::error;
    use std::signer;

    /// Error codes
    const E_NOT_ENOUGH_BALANCE: u64 = 1;
    const E_COIN_NOT_INITIALIZED: u64 = 2;

    /// Basic coin structure
    struct Coin has key, store {
        value: u64,
    }

    /// Balance resource
    struct Balance has key {
        coin: Coin,
    }

    /// Initialize account
    public fun initialize(account: &signer) {
        let account_addr = signer::address_of(account);
        assert!(!exists<Balance>(account_addr), error::already_exists(E_COIN_NOT_INITIALIZED));
        
        move_to(account, Balance {
            coin: Coin { value: 0 }
        });
    }

    /// Mint coins
    public fun mint(account: &signer, amount: u64) acquires Balance {
        let account_addr = signer::address_of(account);
        assert!(exists<Balance>(account_addr), error::not_found(E_COIN_NOT_INITIALIZED));
        
        let balance = borrow_global_mut<Balance>(account_addr);
        balance.coin.value = balance.coin.value + amount;
    }

    /// Transfer coins
    public fun transfer(from: &signer, to: address, amount: u64) acquires Balance {
        let from_addr = signer::address_of(from);
        assert!(exists<Balance>(from_addr), error::not_found(E_COIN_NOT_INITIALIZED));
        assert!(exists<Balance>(to), error::not_found(E_COIN_NOT_INITIALIZED));
        
        let from_balance = borrow_global_mut<Balance>(from_addr);
        assert!(from_balance.coin.value >= amount, error::invalid_argument(E_NOT_ENOUGH_BALANCE));
        
        from_balance.coin.value = from_balance.coin.value - amount;
        
        let to_balance = borrow_global_mut<Balance>(to);
        to_balance.coin.value = to_balance.coin.value + amount;
    }

    /// Get balance
    public fun balance_of(account: address): u64 acquires Balance {
        assert!(exists<Balance>(account), error::not_found(E_COIN_NOT_INITIALIZED));
        borrow_global<Balance>(account).coin.value
    }
} 