module ApplicationHelper
  def sidebar_hidden?
    controller_name == 'contests' && action_name == 'index'
  end
end
