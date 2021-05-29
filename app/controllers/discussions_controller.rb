class DiscussionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_discussion, only: [:edit, :update, :destroy, :show]

  def index
    @pagy, @discussions = pagy(Discussion.includes(:category).pinned_first.order(updated_at: :desc))
  end

  def show
    @pagy, @posts = pagy(@discussion.posts.includes(:user, :rich_text_body).order(:created_at))
    @new_post = @discussion.posts.new
  end

  def new
    @discussion = Discussion.new
    @discussion.posts.new
  end

  def create
    @discussion = Discussion.new(discussion_params)

    respond_to do |format|
      if @discussion.save
        format.html { redirect_to @discussion, notice: "Discussion Created"}
      else
        format.html { render :new, status: :unprocessable_entity}
      end
    end
  end

  def edit

  end

  def update
    respond_to do |format|
      if @discussion.update(discussion_params)
        DiscussionBroadcaster.new(@discussion).broadcast!
        format.html { redirect_to @discussion, notice: "Discussion Updated"}
      else
        format.html { render :edit, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @discussion.destroy!
    redirect_to discussions_path, notice: "Discussion Removed"
  end

  private

  def set_discussion
    @discussion = Discussion.find(params[:id])
  end

  def discussion_params
    params.require(:discussion).permit(:name, :category_id, :closed, :pinned, posts_attributes: :body)
  end
end