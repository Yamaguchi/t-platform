
ou = OrganizationUnit.find_or_create_by(name: 'default')
system_user = User.find_or_initialize_by(name: 'root', organization_unit: ou, email: 'admin@chaintope.com')
system_user.password = 'password'
system_user.password_confirmation = 'password'
system_user.save!
ou.update(owner: system_user)

system_role = Role.find_or_create_by(name: 'system', owner: system_user)
system_user_role = UserRole.find_or_create_by(user: system_user, role: system_role, primary: true)

if system_role.entity_privileges.empty?
  ["Team", "User", "Role", "EntityPrivilege", "OrganizationUnit", "Wallet", "Token", "Transaction"].each do |entity_name|
    system_role.entity_privileges << EntityPrivilege.new(entity_name: entity_name, 
      read_access: AccessLevel::GLOBAL,
      create_access: AccessLevel::GLOBAL,
      update_access: AccessLevel::GLOBAL,
      delete_access: AccessLevel::GLOBAL, 
      owner: system_user
    )
  end
end

guest_role = Role.find_or_create_by(name: 'guest', owner: system_user)
if guest_role.entity_privileges.empty?
  ["User", "Wallet", "Token", "Transaction"].each do |entity_name|
    guest_role.entity_privileges << EntityPrivilege.new(entity_name: entity_name, 
      read_access: AccessLevel::BASIC,
      create_access: AccessLevel::BASIC,
      update_access: AccessLevel::BASIC,
      delete_access: AccessLevel::BASIC, 
      owner: system_user
    )
  end
end
