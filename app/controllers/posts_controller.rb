class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :authenticate, except: [:index, :show]
  before_action :require_admin_or_creator, only: [:edit, :update]
  helper_method :admin_or_creator

  def index
    @posts = Post.limit(Post::PER_PAGE).offset(params[:offset])
    @num_pages = (Post.count / Post::PER_PAGE.to_f).ceil
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user

    if @post.save
      flash[:notice] = 'Post was created'
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      flash[:notice] = 'Post was updated'
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def vote
    @vote = Vote.create(vote: params[:vote], creator: current_user,
                        voteable: @post)
    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:notice] = 'Your vote has been added'
        else
          flash[:error] = 'You cannot vote twice on the same item'
        end
        redirect_to :back
      end

      format.js
    end
  end

  def admin_or_creator?
    logged_in? && (current_user.admin? || current_user == @post.creator)
  end

  private
  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end

  def set_post
    @post = Post.find_by slug: params[:id]
  end

  def require_admin_or_creator
    access_denied unless admin_or_creator?
  end
end
