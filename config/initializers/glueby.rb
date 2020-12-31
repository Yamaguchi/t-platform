# Edit configuration for connection to tapyrus core
yaml = Pathname.new(Rails.root.join('config', 'tapyrus.yml')) 
config = YAML.load(ERB.new(yaml.read).result).deep_symbolize_keys

Glueby::Wallet.configure(config[Rails.env.to_sym])

Glueby::Internal::Wallet::AR.define_singleton_method(:table_name_prefix) do
  "glueby_"
end
