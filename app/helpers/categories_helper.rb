module CategoriesHelper

  # render categories in treelike mode
  # with offsetting for each children categories.
  def render_subtree node
    content_tag :div, class: 'media' do
      render_node(node) do
        node.children.map do |subnode|
          render_subtree subnode
        end.join().html_safe
      end
    end
  end

  # render categories in treelike mode
  # with checking functionality for view forms.
  def render_form_subtree node, f
    content_tag :div, class: 'media' do
      render_form_node(node, f) do
        node.children.map do |subnode|
          render_form_subtree subnode, f
        end.join().html_safe
      end
    end
  end


  # render one node line with image, radio_button, title
  def render_form_node node, f, &block
    content_tag(:div, class: 'pull-left' ) do
      f.radio_button(:category_id, node.id)+
      image_tag(node.image.url(:xxs))
    end +
    content_tag(:div, class: 'media-body') do
      content_tag(:h4, node.title, class: 'media-heading') +
      yield
    end
  end

  # render one node line with title, action buttons.
  def render_node node, &block
    content_tag(:div, image_tag(node.image.url(:xs)), class: 'pull-left' )+
    content_tag(:div, class: 'media-body') do
      content_tag(:h4, node.title, class: 'media-heading')+
      content_tag(:div, class: '') do
        link_to('редактировать', edit_admin_category_path(node), class: 'btn btn-primary')+
        link_to('удалить', admin_category_path(node), method: :delete, class: 'btn btn-default')+
        link_to('создать потомка', new_admin_category_path(parent: node), class: 'btn btn-default')
      end +
      yield
    end
  end
end