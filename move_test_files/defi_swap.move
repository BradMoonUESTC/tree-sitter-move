module 0x1::defi_swap {
    use std::signer;
    use aptos_framework::coin::{Self, Coin};
    use aptos_framework::account;

    /// Error codes
    const E_INSUFFICIENT_LIQUIDITY: u64 = 1;
    const E_POOL_NOT_EXISTS: u64 = 2;
    const E_ZERO_AMOUNT: u64 = 3;
    const E_SLIPPAGE_EXCEEDED: u64 = 4;

    /// Liquidity pool
    struct LiquidityPool<phantom CoinX, phantom CoinY> has key {
        coin_x_reserve: Coin<CoinX>,
        coin_y_reserve: Coin<CoinY>,
        total_supply: u64,
        fee_rate: u64, // Basis points, e.g. 30 means 0.3%
    }

    /// LP token
    struct LPToken<phantom CoinX, phantom CoinY> has key, store {
        value: u64,
    }

    /// Liquidity provider information
    struct LiquidityProvider<phantom CoinX, phantom CoinY> has key {
        lp_tokens: LPToken<CoinX, CoinY>,
    }

    /// Swap event
    struct SwapEvent<phantom CoinX, phantom CoinY> has drop, store {
        amount_in: u64,
        amount_out: u64,
        is_x_to_y: bool,
        trader: address,
    }

    /// Create liquidity pool
    public fun create_pool<CoinX, CoinY>(
        admin: &signer,
        initial_x: Coin<CoinX>,
        initial_y: Coin<CoinY>,
        fee_rate: u64,
    ) {
        let admin_addr = signer::address_of(admin);
        assert!(!exists<LiquidityPool<CoinX, CoinY>>(admin_addr), E_POOL_NOT_EXISTS);
        
        let x_value = coin::value(&initial_x);
        let y_value = coin::value(&initial_y);
        assert!(x_value > 0 && y_value > 0, E_ZERO_AMOUNT);
        
        // 计算初始LP代币供应量 (geometric mean)
        let initial_supply = sqrt(x_value * y_value);
        
        move_to(admin, LiquidityPool<CoinX, CoinY> {
            coin_x_reserve: initial_x,
            coin_y_reserve: initial_y,
            total_supply: initial_supply,
            fee_rate,
        });
        
        // Give admin LP tokens
        move_to(admin, LiquidityProvider<CoinX, CoinY> {
            lp_tokens: LPToken<CoinX, CoinY> { value: initial_supply },
        });
    }

    /// Add liquidity
    public fun add_liquidity<CoinX, CoinY>(
        provider: &signer,
        pool_addr: address,
        coin_x: Coin<CoinX>,
        coin_y: Coin<CoinY>,
    ) acquires LiquidityPool, LiquidityProvider {
        let provider_addr = signer::address_of(provider);
        assert!(exists<LiquidityPool<CoinX, CoinY>>(pool_addr), E_POOL_NOT_EXISTS);
        
        let pool = borrow_global_mut<LiquidityPool<CoinX, CoinY>>(pool_addr);
        let x_amount = coin::value(&coin_x);
        let y_amount = coin::value(&coin_y);
        
        assert!(x_amount > 0 && y_amount > 0, E_ZERO_AMOUNT);
        
        // Calculate LP token amount
        let x_reserve = coin::value(&pool.coin_x_reserve);
        let y_reserve = coin::value(&pool.coin_y_reserve);
        
        let lp_tokens_to_mint = if (pool.total_supply == 0) {
            sqrt(x_amount * y_amount)
        } else {
            let x_ratio = (x_amount * pool.total_supply) / x_reserve;
            let y_ratio = (y_amount * pool.total_supply) / y_reserve;
            if (x_ratio < y_ratio) x_ratio else y_ratio
        };
        
        // Merge coins into pool
        coin::merge(&mut pool.coin_x_reserve, coin_x);
        coin::merge(&mut pool.coin_y_reserve, coin_y);
        pool.total_supply = pool.total_supply + lp_tokens_to_mint;
        
        // Give provider LP tokens
        if (!exists<LiquidityProvider<CoinX, CoinY>>(provider_addr)) {
            move_to(provider, LiquidityProvider<CoinX, CoinY> {
                lp_tokens: LPToken<CoinX, CoinY> { value: lp_tokens_to_mint },
            });
        } else {
            let provider_info = borrow_global_mut<LiquidityProvider<CoinX, CoinY>>(provider_addr);
            provider_info.lp_tokens.value = provider_info.lp_tokens.value + lp_tokens_to_mint;
        };
    }

    /// Swap: X to Y
    public fun swap_x_to_y<CoinX, CoinY>(
        trader: &signer,
        pool_addr: address,
        coin_x: Coin<CoinX>,
        min_coin_y: u64,
    ): Coin<CoinY> acquires LiquidityPool {
        let trader_addr = signer::address_of(trader);
        assert!(exists<LiquidityPool<CoinX, CoinY>>(pool_addr), E_POOL_NOT_EXISTS);
        
        let pool = borrow_global_mut<LiquidityPool<CoinX, CoinY>>(pool_addr);
        let x_in = coin::value(&coin_x);
        assert!(x_in > 0, E_ZERO_AMOUNT);
        
        // Calculate output amount (considering fees)
        let x_reserve = coin::value(&pool.coin_x_reserve);
        let y_reserve = coin::value(&pool.coin_y_reserve);
        
        let x_in_with_fee = x_in * (10000 - pool.fee_rate);
        let numerator = x_in_with_fee * y_reserve;
        let denominator = x_reserve * 10000 + x_in_with_fee;
        let y_out = numerator / denominator;
        
        assert!(y_out >= min_coin_y, E_SLIPPAGE_EXCEEDED);
        assert!(y_out < y_reserve, E_INSUFFICIENT_LIQUIDITY);
        
        // Execute swap
        coin::merge(&mut pool.coin_x_reserve, coin_x);
        let coin_y_out = coin::extract(&mut pool.coin_y_reserve, y_out);
        
        coin_y_out
    }

    /// Swap: Y to X
    public fun swap_y_to_x<CoinX, CoinY>(
        trader: &signer,
        pool_addr: address,
        coin_y: Coin<CoinY>,
        min_coin_x: u64,
    ): Coin<CoinX> acquires LiquidityPool {
        let trader_addr = signer::address_of(trader);
        assert!(exists<LiquidityPool<CoinX, CoinY>>(pool_addr), E_POOL_NOT_EXISTS);
        
        let pool = borrow_global_mut<LiquidityPool<CoinX, CoinY>>(pool_addr);
        let y_in = coin::value(&coin_y);
        assert!(y_in > 0, E_ZERO_AMOUNT);
        
        // Calculate output amount (considering fees)
        let x_reserve = coin::value(&pool.coin_x_reserve);
        let y_reserve = coin::value(&pool.coin_y_reserve);
        
        let y_in_with_fee = y_in * (10000 - pool.fee_rate);
        let numerator = y_in_with_fee * x_reserve;
        let denominator = y_reserve * 10000 + y_in_with_fee;
        let x_out = numerator / denominator;
        
        assert!(x_out >= min_coin_x, E_SLIPPAGE_EXCEEDED);
        assert!(x_out < x_reserve, E_INSUFFICIENT_LIQUIDITY);
        
        // Execute swap
        coin::merge(&mut pool.coin_y_reserve, coin_y);
        let coin_x_out = coin::extract(&mut pool.coin_x_reserve, x_out);
        
        coin_x_out
    }

    /// Get pool information
    public fun get_pool_info<CoinX, CoinY>(pool_addr: address): (u64, u64, u64, u64) acquires LiquidityPool {
        assert!(exists<LiquidityPool<CoinX, CoinY>>(pool_addr), E_POOL_NOT_EXISTS);
        
        let pool = borrow_global<LiquidityPool<CoinX, CoinY>>(pool_addr);
        (
            coin::value(&pool.coin_x_reserve),
            coin::value(&pool.coin_y_reserve),
            pool.total_supply,
            pool.fee_rate
        )
    }

    /// Simple square root calculation (Newton's method)
    fun sqrt(x: u64): u64 {
        if (x == 0) return 0;
        let z = x;
        let y = (x + 1) / 2;
        // Simplified version, returns approximate value
        if (y < z) {
            y
        } else {
            z
        }
    }
} 