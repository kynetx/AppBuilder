module ApplicationsHelper
  
  def application_actions(app)
    actions = []
    actions << link_to("Duplicate", duplicate_path(app["appid"]))
    actions << link_to("Delete", application_path(app["appid"]), :confirm => 'Are you sure?', :method => :delete )
    return actions.join(" | ")
  end
  
end
