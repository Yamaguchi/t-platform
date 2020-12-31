namespace :blockchain do
  task start: :environment do
    BlockchainTask.schedule!
  end

  task clean: :environment do
    ActiveRecord::Base.transaction do
      Blockchain.destroy_all
      Glueby::Internal::Wallet::AR::Utxo.destroy_all
    end
  end
end
