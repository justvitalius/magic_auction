module UserBarHelper

  # show links for current_user.
  # show 'login' for unauthenticated user.
  # show 'private office' and 'logout' for authenitaced user
  def user_bar
    content_tag(:ul, class: 'nav navbar-nav navbar-right') do
      if current_user
        raw(private_office_link)+
        raw(logout_link)
      else
        raw(login_link)
      end
    end
  end


  protected
  def login_link
    content_tag(:li) do
      link_to t('.login'), new_user_session_path
    end
  end

  def private_office_link
    content_tag :li do
      link_to current_user.email, edit_user_registration_path
    end
  end

  def logout_link
    content_tag :li do
      link_to t('.logout'), destroy_user_session_path, method: :delete
    end
  end
end