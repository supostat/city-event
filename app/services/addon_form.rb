class AddonForm < BaseService
  AVAILABLE_ADDONS =
      [
          Addons::Text,
          Addons::Checkbox,
          Addons::Scale,
          Addons::Dropdown

      ]

  ADDON_TYPES = AVAILABLE_ADDONS.inject({}) do |result, addon|
    addon_name = addon.to_s.split("::").last()
    result[addon_name] = addon.to_s
    result
  end
end