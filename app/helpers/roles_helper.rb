module RolesHelper
  def access_level_label(access_right)
    case access_right
    when AccessLevel::GLOBAL
      "GLOBAL"
    when AccessLevel::DEEP
      "DEEP"
    when AccessLevel::LOCAL
      "LOCAL"
    when AccessLevel::BASIC
      "BASIC"
    when AccessLevel::NONE
      "NONE"
    end
  end
end
