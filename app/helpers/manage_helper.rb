module ManageHelper

  def manage_actions_helper(u)
    actions = []
    remove_link = link_to("Remove", :controller => "manage",
      :action => "remove_user", 
      :id => current_application.application_id, 
      :userid => u["kynetxuserid"] )
    
    if u["role"] == "developer" && current_user.owns_current?
      actions << link_to("Make Owner", "#", :onclick => "showAltRow(this)") 
      actions << remove_link
    end
    
    if u["kynetxuserid"] == current_user.userid && u["role"] != "owner"
      actions << remove_link
    end
    
    return actions.join(" | ")
    
  end
  
end
