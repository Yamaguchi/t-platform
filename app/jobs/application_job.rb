class ApplicationJob < ActiveJob::Base
  before_perform :setup

  def setup
    yaml = Pathname.new(Rails.root.join('config', 'tapyrus.yml'))
    config = YAML.load(ERB.new(yaml.read).result).deep_symbolize_keys
    config = config[Rails.env.to_sym]
    Tapyrus.chain_params = config[:network]
    @client = Tapyrus::RPC::TapyrusCoreClient.new(config)
  end

  def client
    @client
  end
end
