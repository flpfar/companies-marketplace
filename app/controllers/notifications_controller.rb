class NotificationsController < ApplicationController
  def seen
    notification = Notification.find(params[:notification_id])
    notification.seen!
    redirect_to notification.path
  end
end
