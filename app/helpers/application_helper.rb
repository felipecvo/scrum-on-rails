module ApplicationHelper
  # Yield the content for a given block. If the block yiels nothing, the optionally specified default text is shown.
  #
  #   yield_or_default(:user_status)
  #
  #   yield_or_default(:sidebar, "Sorry, no sidebar")
  #
  # +target+ specifies the object to yield.
  # +default_message+ specifies the message to show when nothing is yielded. (Default: "")
  def yield_or_default(message, default_message = "")
    message.nil? ? default_message : message
  end

  # Create tab.
  #
  # The tab will link to the first options hash in the all_options array,
  # and make it the current tab if the current url is any of the options
  # in the same array.
  #
  # +name+ specifies the name of the tab
  # +all_options+ is an array of hashes, where the first hash of the array is the tab's link and all others will make the tab show up as current.
  #
  # If now options are specified, the tab will point to '#', and will never have the 'active' state.
  def tab_to(name, all_options = nil)
    url = all_options.is_a?(Array) ? all_options[0].merge({:only_path => false}) : "#"

    current_url = url_for(:action => @current_action, :only_path => false)
    html_options = {}

    if all_options.is_a?(Array)
      all_options.each do |o|
        if url_for(o.merge({:only_path => false})) == current_url
          html_options = {:class => "current"}
          break
        end
      end
    end

    link_to(name, url, html_options)
  end

  # Return true if the currently logged in user is an admin
  def admin?
    logged_in? && current_user.has_role?(:admin)
  end

  # Write a secure email adress
  def secure_mail_to(email)
    mail_to email, nil, :encode => 'javascript'
  end

  def cell(label, value)
    "<tr>
  		<td class='label' nowrap='nowrap'>#{label}</td>
  		<td class='value'>#{value}</td>
  	</tr>"
  end

  def cell_separator
    "<tr>
  		<td colspan='2' class='separator'></td>
  	</tr>"
  end

  #DRY flash messages
  def flash_message
    messages = ""
    [:notice, :info, :warning, :error].each do|type|
      if flash[type]
        messages= "<div id=\"#{type}\">#{flash[type]}</div>"
      end
    end
    messages
  end

  #usage: <%= edit_in_place_for(@list, :name) or edit_in_place(@comment, :body, :url => url_for(@post, @comment)) %>
  def edit_in_place(record, field, options={})
    options[:tag] ||= :div
    options[:url] ||= url_for(record)
    options[:id] ||= "#{dom_id(record)}_#{field}"
    content_tag options[:tag], record.send(field), :class => 'editable', :rel => options[:url], :id => options[:id]
  end

  #usage: <%= edit_in_place([@post, @comment], :body) %>
  def edit_in_place_for(resource, field, options={})
    # Get record to be edited. If resource is an array, pull it out.
    record = resource.is_a?(Array) ? resource.last : resource

    options[:id]  ||= "#{dom_id(record)}_#{field}"
    options[:tag] ||= :div
    options[:url] ||= url_for(resource)
    options[:rel] = options.delete(:url)

    classes = options[:class].try(:split, ' ') || []
    classes << 'editable'
    options[:class] = classes.uniq.join(' ')

    content_tag(options[:tag], record.send(field), options)
  end



end
