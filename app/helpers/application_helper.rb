module ApplicationHelper
  def active_tab(tab_name = nil)
    if controller_name == 'sessions' && action_name == 'new' && tab_name == "login"
      "active"
    elsif controller_name == 'registrations' && action_name == 'edit' && tab_name == "upate_profile"
      "active"
    elsif controller_name == 'photos' && action_name == 'new' && tab_name == "new_photo"
      "active"
    elsif controller_name == 'photos' && action_name == 'index' && tab_name == "index_photo"
      "active"
    elsif controller_name == 'home' && action_name == 'index' && tab_name == "home"
      "active"
    end
  end
end
