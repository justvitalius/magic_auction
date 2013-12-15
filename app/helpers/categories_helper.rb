module CategoriesHelper
  def render_subtree node
    content_tag :div, class: 'col-xs-offset-1' do
      content_tag(:div, render_node(node), class: '')+
      node.children.map do |subnode|
        render_subtree subnode
      end.join().html_safe
    end
  end


  def render_node node
    content_tag(:div, node.id, class: 'col-xs-1')+
    content_tag(:div, node.title, class: 'col-xs-3')+
    content_tag(:div, node.image_url(:xs), class: 'col-xs-2')+
    link_to('создать потомка', new_category_path(parent: node))
  end
end