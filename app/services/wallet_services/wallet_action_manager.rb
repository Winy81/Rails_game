module WalletServices
  class WalletActionManager < WalletProcessor

    def initialize(user, amount)
      @user = user
      @amount = amount
    end

    def action_amount_calculator
      Wallet.find_by(user_id:@user.id).update_attributes(amount:@amount)
    end

  end
end