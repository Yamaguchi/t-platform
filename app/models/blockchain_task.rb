class BlockchainTask
  include Delayed::RecurringJob
  run_every 1.minutes
  queue :default
  def perform
    BlockchainJob.perform_later
  end
end
