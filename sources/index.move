module MyModule::GrantTracker {

    use aptos_framework::signer;
    use aptos_framework::coin::{Self, Coin};
    use aptos_framework::aptos_coin::AptosCoin;
    use std::vector;

    /// A resource to represent a grant with its milestones and payout details.
    struct Grant has key {
        recipient: address,
        total_amount: u64,
        milestone_paid: u64,
        milestones_completed: u64,
        milestone_payouts: vector<u64>, // Percentage of total amount per milestone
    }
    
    /// Error code for when a milestone index is invalid.
    const E_INVALID_MILESTONE_INDEX: u64 = 0;

    /// Creates a new grant with a recipient and a payout schedule.
    /// This function moves the Grant resource to the `grantor`'s account.
    public entry fun create_grant(
        grantor: &signer,
        recipient: address,
        total_amount: u64,
        milestone_payouts: vector<u64>
    ) {
        let grant_info = Grant {
            recipient,
            total_amount,
            milestone_paid: 0,
            milestones_completed: 0,
            milestone_payouts,
        };
        move_to(grantor, grant_info);
    }
    
    /// Attests a milestone and pays the corresponding amount to the recipient.
    /// This is an entry function, callable from an external transaction.
    public entry fun attest_and_payout_milestone(
        grantor: &signer,
        milestone_index: u64
    ) acquires Grant {
        let grantor_addr = signer::address_of(grantor);
        let grant_info = borrow_global_mut<Grant>(grantor_addr);
        
        assert!(milestone_index < vector::length(&grant_info.milestone_payouts), E_INVALID_MILESTONE_INDEX);
        assert!(milestone_index == grant_info.milestones_completed, 1); // E_MILESTONE_OUT_OF_ORDER
        
        let payout_percentage = *vector::borrow(&grant_info.milestone_payouts, milestone_index);
        let payout_amount = grant_info.total_amount * payout_percentage / 100;
        
        let coin_to_transfer = coin::withdraw<AptosCoin>(grantor, payout_amount);
        coin::deposit<AptosCoin>(grant_info.recipient, coin_to_transfer);
        
        // Update the grant status
        grant_info.milestone_paid = grant_info.milestone_paid + 1;
        grant_info.milestones_completed = grant_info.milestones_completed + 1;
    }
}