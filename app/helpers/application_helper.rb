# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def app_menu(current, ruleset_id, additional_breadcrumb=nil)
    
    # TODO: Replace these with the actual images when we get them
    menu_items = [
      {:controller => "applications", :action => "index", :link => "App List"},
      {:controller => "manage", :action => "index", :link => current == :manage ? "<img src='/images/nav/manage-current.png'/>" : "<img src='/images/nav/manage.png'/>"},
      {:controller => "applications", :action => "edit", :link => current == :edit ? "<img src='/images/nav/edit-current.png'/>" : "<img src='/images/nav/edit.png'/>"},
      {:controller => "test_app", :action => "index", :link => current == :test ? "<img src='/images/nav/test-current.png'/>" : "<img src='/images/nav/test.png'/>"},
      {:controller => "deploy_app", :action => "index", :link => current == :deploy ? "<img src='/images/nav/deploy-current.png'/>" : "<img src='/images/nav/deploy.png'/>"},
      {:controller => "distribute_app", :action => "index", :link => current == :distribute ? "<img src='/images/nav/distribute-current.png'/>" : "<img src='/images/nav/distribute.png'/>"}
    ]
    
    h = "<span class='breadcrumb'>#{current_application.name} (#{ruleset_id}) / #{current.to_s.titleize}"
    h += " / #{additional_breadcrumb}" if additional_breadcrumb
    h += "</span>"
    h += '<div id="edit-nav">'
    menu_items.each do |menu_item|
      h += link_to menu_item[:link], 
        {:controller => menu_item[:controller], :action => menu_item[:action], :id => ruleset_id}
      # h += " | " unless menu_item == menu_items.last
    end
    h += '</div><div class="clear"></div>'
    h += '<div id="distribute-dropdown">'
    h += link_to "InfoCard", :controller => "distribute_app", :action => "infocard", :id => params[:id] 
    h += link_to "Bookmarklet", :controller => "distribute_app", :action => "bookmarklet", :id => params[:id] 
    h += link_to "Browser Extension", :controller => "distribute_app", :action => "extension", :id => params[:id] 
    h += link_to "Site Tags", :controller => "distribute_app", :action => "tags", :id => params[:id] 
    h += link_to "Marketplace", :controller => "distribute_app", :action => "marketplace", :id => params[:id]
    h += '</div>'
    return h    
  end
  
  def quick_table(collection, fields, additional_rows={})   
    return "" if fields.to_a.empty? 
    return "" if collection.to_a.empty?

    s = '<table class="qtable" cellspacing="0"><tr>'

    fields.each do |field|
      if field[:visible] == true || field[:visible].nil?
        if field[:align]
          s += "<th align='#{field[:align]}'>"
        else
          s += "<th align='left'>"
        end
        s += "#{field[:field]}</th>"
      end
    end
    s += "</tr>"

    counter = 1
    collection.each do |c|
      s += "<tr>"
      fields.each do |field|       
        if field[:visible] == true || field[:visible].nil?
          align = field[:align] ? field[:align] : "left"
          col_class = field == fields.last ? "last_col" : ""
          col_width = field[:width] ? field[:width] : ""

          s += "<td align='#{align}' class = '#{col_class}' width = '#{col_width}'>"       
          s += "#{field[:value].call(c)}</td>"
        end
      end       
      s += "</tr>"
      if additional_rows[:altrow]
        s += tag("tr", additional_rows[:altrow][:opts], true)
        s += additional_rows[:altrow][:value].call(c)
        s += "</tr>"
      end
      counter += 1
    end
    
    if additional_rows[:lastrow]
      s += tag("tr", additional_rows[:lastrow][:opts], true)
      s += additional_rows[:lastrow][:value].call
      s += "</tr>"
    end
    return s += "</table>"

  end
  
  
end

