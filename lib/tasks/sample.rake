namespace :sample do  
  task :testuser, [:number] => [:environment] do |_, args|
    ActiveRecord::Base.transaction do
      ou = OrganizationUnit.find_by(name: 'default')
      guest_role = Role.find_by(name: 'guest')
      args.number.to_i.times do |i|
        new_user = User.find_or_create_by(
          name: "testuser#{i}", 
          organization_unit: ou, 
          email: "testuser#{i}@example.com"
        )
        new_user.update(
          password: 'password',
          password_confirmation: 'password',
          confirmed_at: Time.now
        );
        UserRole.find_or_create_by(user: new_user, role: guest_role, primary: true)

        new_user.create_wallet(new_user)
      end
    end
  end

  task :issue, [:name, :amount, :token_type] => :environment do |_, args|
    system_user = User.joins(:roles).find_by(roles: { name: 'system' });
    token_create_params = {
      name: args.name,
      amount: args.amount,
      token_type: args.token_type.to_i(16),
      issuer: system_user.wallets.first
    }
    ActiveRecord::Base.transaction do
      token = TokenIssueForm.new(token_create_params)
      tx = token.create_by!(system_user)
      p tx
    end
  end

  task :distribute, [:color_id, :amount] => :environment do |_, args|
    system_user = User.joins(:roles).find_by(roles: { name: 'system' });
    ActiveRecord::Base.transaction do
      User.where(role: { name: 'guest' }).each do |user|
        token_transfer_params = {
          token: token,
          sender: system_user.wallets.first,
          amount: args.amount,
          receiver: user.wallets.first
        }
        token_transfer_form = TokenTransferForm.new(token_transfer_params)
        p token_transfer_form.transfer_by!(system_user)
      end
    end
  end
end





