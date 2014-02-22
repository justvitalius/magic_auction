module ResourceHelper
  def sortable(column, title = nil)
    title ||= resource_class.human_attribute_name(attr)
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end


  def render_attr resource, attr
    #if resource.kind_of? Draper::Decorator
    #  resource.public_send(attr)
    #else
    #  dirty_attr resource, attr
    #end
    dirty_attr resource, attr
  end


  def dirty_attr resource, attr
    result = resource.public_send(attr)
    #empty_html = NullAttribute.new(self) # candidate for NullObject
    #case attr
    #  when 'preview' then image_tag(resource.preview_url(:icon)) if result
    #  else
    #    result.blank?? empty_html : result.to_s
    #end
  end


end