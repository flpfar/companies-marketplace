module UsersHelper
  def show_user_title
    current_user.social_name
  end
end
