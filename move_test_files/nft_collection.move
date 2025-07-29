module 0x1::nft_collection {
    use std::string::{Self, String};
    use std::vector;
    use std::option::{Self, Option};
    use aptos_framework::event;

    /// Error codes
    const E_NOT_OWNER: u64 = 1;
    const E_TOKEN_NOT_EXIST: u64 = 2;
    const E_COLLECTION_NOT_EXIST: u64 = 3;

    /// NFT token structure
    struct Token has key, store {
        id: u64,
        name: String,
        description: String,
        uri: String,
        owner: address,
    }

    /// NFT collection
    struct Collection has key {
        name: String,
        description: String,
        uri: String,
        tokens: vector<Token>,
        next_token_id: u64,
    }

    /// Transfer event
    struct TransferEvent has drop, store {
        token_id: u64,
        from: address,
        to: address,
    }

    /// Mint event
    struct MintEvent has drop, store {
        token_id: u64,
        owner: address,
        name: String,
    }

    /// Create NFT collection
    public fun create_collection(
        creator: &signer,
        name: String,
        description: String,
        uri: String,
    ) {
        let creator_addr = std::signer::address_of(creator);
        assert!(!exists<Collection>(creator_addr), E_COLLECTION_NOT_EXIST);
        
        move_to(creator, Collection {
            name,
            description,
            uri,
            tokens: vector::empty<Token>(),
            next_token_id: 1,
        });
    }

    /// Mint NFT
    public fun mint_token(
        creator: &signer,
        to: address,
        name: String,
        description: String,
        uri: String,
    ) acquires Collection {
        let creator_addr = std::signer::address_of(creator);
        assert!(exists<Collection>(creator_addr), E_COLLECTION_NOT_EXIST);
        
        let collection = borrow_global_mut<Collection>(creator_addr);
        let token_id = collection.next_token_id;
        
        let token = Token {
            id: token_id,
            name: string::utf8(b""),
            description,
            uri,
            owner: to,
        };
        
        string::append(&mut token.name, name);
        vector::push_back(&mut collection.tokens, token);
        collection.next_token_id = token_id + 1;

        // 发出铸造事件
        event::emit<MintEvent>(MintEvent {
            token_id,
            owner: to,
            name,
        });
    }

    /// Transfer NFT
    public fun transfer_token(
        from: &signer,
        to: address,
        creator: address,
        token_id: u64,
    ) acquires Collection {
        let from_addr = std::signer::address_of(from);
        assert!(exists<Collection>(creator), E_COLLECTION_NOT_EXIST);
        
        let collection = borrow_global_mut<Collection>(creator);
        let i = 0;
        let len = vector::length(&collection.tokens);
        
        while (i < len) {
            let token = vector::borrow_mut(&mut collection.tokens, i);
            if (token.id == token_id) {
                assert!(token.owner == from_addr, E_NOT_OWNER);
                token.owner = to;
                
                // 发出转移事件
                event::emit<TransferEvent>(TransferEvent {
                    token_id,
                    from: from_addr,
                    to,
                });
                
                return
            };
            i = i + 1;
        };
        
        abort E_TOKEN_NOT_EXIST
    }

    /// Get token information
    public fun get_token_info(creator: address, token_id: u64): (String, String, String, address) acquires Collection {
        assert!(exists<Collection>(creator), E_COLLECTION_NOT_EXIST);
        
        let collection = borrow_global<Collection>(creator);
        let i = 0;
        let len = vector::length(&collection.tokens);
        
        while (i < len) {
            let token = vector::borrow(&collection.tokens, i);
            if (token.id == token_id) {
                return (token.name, token.description, token.uri, token.owner)
            };
            i = i + 1;
        };
        
        abort E_TOKEN_NOT_EXIST
    }
} 