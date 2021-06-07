# To deliver this notification:
#
# NewPostNotification.with(post: @post).deliver_later(current_user)
# NewPostNotification.with(post: @post).deliver(current_user)

class NewPostNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :email, mailer: "UserMailer" #default: 5.minutes, unless: :read?
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :post

  # Define helper methods to make rendering easier.
  #
  # def message
  #   t(".message")
  # end
  #
  # def url
  #   post_path(params[:post])
  # end
  #
  def message
    "New Post in #{params[:post].discussion.name}"
  end

  def url
    discussion_path(params[:post].discussion)
  end
end