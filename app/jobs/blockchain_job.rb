class BlockchainJob < ApplicationJob
  queue_as :default

  def perform(*args)

    response = client.getblockchaininfo
    ActiveRecord::Base.transaction do 
      blockchain = Blockchain.first
      height = blockchain&.blocks || 0
      blockchain = if blockchain
        blockchain.update(blockchain_params(response))
        blockchain.reload
      else
        Blockchain.create(blockchain_params(response))
      end

      current_height = blockchain.blocks
      task = Rake::Task["glueby:contract:wallet_adapter:import_block"]
      while(height <= current_height)
        block_hash = client.getblockhash(height)
        pp "import block: #{block_hash}"
        task.invoke(block_hash)
        task.reenable
        height += 1
      end
    end
  end

  def blockchain_params(params)
    params.except("warnings", "aggregatePubkeys")
  end
end
