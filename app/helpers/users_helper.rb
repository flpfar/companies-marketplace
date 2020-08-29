module UsersHelper
  def show_user_title
    return current_user.social_name if current_user.enabled?

    current_user.email
  end
end
