module EntityPrivilegesHelper
  def access_level_options
    {
      "GLOBAL": AccessLevel::GLOBAL,
      "DEEP": AccessLevel::DEEP,
      "LOCAL": AccessLevel::LOCAL,
      "BASIC": AccessLevel::BASIC,
      "NONE": AccessLevel::NONE
    }
  end

  def supported_entity_name(role)
    all = [ "EntityPrivilege", "OrganizationUnit", "Role", "Team", "Token", "Transaction", "User", "Wallet"]
    all - role.entity_privileges.map(&:entity_name)
  end
end
