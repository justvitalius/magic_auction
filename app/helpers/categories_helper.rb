module CategoriesHelper
  def render_subtree node
    content_tag :div, class: 'media' do
      content_tag(:div, image_tag(node.image.url(:xs)), class: 'pull-left' )+
      content_tag(:div, class: 'media-body') do
        render_node(node) +
        node.children.map do |subnode|
          render_subtree subnode
        end.join().html_safe
      end
    end
  end


  def render_node node
    content_tag(:h4, node.title, class: 'media-heading')+
    content_tag(:div, class: '') do
      link_to('редактировать', edit_category_path(node), class: 'btn btn-primary')+
      link_to('удалить', category_path(node), method: :delete, class: 'btn btn-default')+
      link_to('создать потомка', new_category_path(parent: node), class: 'btn btn-default')
    end
  end
end