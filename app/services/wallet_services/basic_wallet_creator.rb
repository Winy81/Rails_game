module WalletServices
  class BasicWalletCreator < WalletProcessor

    def initialize(user)
      @user = user
    end

    def setup_starter_amount
      Wallet.create(user_id:@user.id, amount:WalletServices::WalletProcessor::STARTER_AMOUNT)
    end

  end
end