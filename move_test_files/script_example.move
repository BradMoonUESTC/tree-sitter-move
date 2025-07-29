script {
    use std::debug;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Simple transfer script
    fun main(sender: &signer, recipient: address, amount: u64) {
        // Check sender balance
        let sender_addr = std::signer::address_of(sender);
        let balance = coin::balance<AptosCoin>(sender_addr);
        
        debug::print(&std::string::utf8(b"Sender balance: "));
        debug::print(&balance);
        
        // Execute transfer
        if (balance >= amount) {
            coin::transfer<AptosCoin>(sender, recipient, amount);
            debug::print(&std::string::utf8(b"Transfer successful"));
        } else {
            debug::print(&std::string::utf8(b"Insufficient balance"));
        };
    }
} 