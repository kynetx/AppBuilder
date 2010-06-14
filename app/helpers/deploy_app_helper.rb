module DeployAppHelper
  
  def note_helper(v)
    note = v["note"]
    
    h = ""
    if note.blank?
      h += link_to "[ Add Note ]", "#", :onclick => "showAltRow(this);"
    else
      h += link_to note, "#", :onclick => "showAltRow(this);"
    end
    
    return h
  end
  
  
end
