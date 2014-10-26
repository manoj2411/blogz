class BlogsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index]
  before_action :set_blog, only: [:show, :edit, :update, :destroy, :update_status]
  before_action :authorise_user_for_update, only: [:edit, :update]

  # GET /blogs
  def index
    if user_signed_in?
      if current_user.is_admin? || current_user.is_editor?
        @search = Blog.includes(:user).search(params[:q])
      else
        @search = Blog.published_or_users_owned(current_user).includes(:user).search(params[:q])
      end
    else
      @search = Blog.published.includes(:user).search(params[:q])
    end
    @blogs = @search.result
  end

  # GET /blogs/1
  def show
    if !current_user.is_owner?( @blog ) and !@blog.is_published? and !current_user.is_editor?
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'You are not allowed to view this blog post!' }
      end
    else
      if current_user.is_owner? @blog
        @comments = @blog.comments.arrange(order: :created_at)
      else
        @comments = @blog.comments.approved_or_users_owned(current_user).arrange(order: :created_at)
      end
    end
  end

  # GET /blogs/new
  def new
    @blog = Blog.new
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs
  def create
    @blog = current_user.blogs.new(blog_params)

    respond_to do |format|
      if @blog.save
        format.html { redirect_to @blog, notice: 'Blog was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /blogs/1
  def update
    if current_user.is_owner?( @blog )
      respond_to do |format|
        if @blog.update(blog_params)
          format.html { redirect_to @blog, notice: 'Blog was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end
  end

  # DELETE /blogs/1
  def destroy
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to blogs_url, notice: 'Blog was successfully destroyed.' }
    end
  end

  def update_status
    # Does the user have permission to update the blog status?
    respond_to do |format|
      format.js do
        @blog.assign_attributes status_updated_by: current_user
        if current_user.can_update_status?( @blog )
          unless @blog.update(blog_params)
            @error = true
          end
        else
          @error = 'unauthorised'
        end
      end
    end
  end

  #  ===================
  #  = Private methods =
  #  ===================
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = action_name == 'show' ? Blog.includes(:comments).find(params[:id]) : Blog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_params
      if action_name == 'update_status'
        params.require(:blog).permit(:status)
      else
        params.require(:blog).permit(:title, :content, :status, :users_id, :image, :remove_image)
      end
    end

    def authorise_user_for_update
      redirect_to root_path, notice: 'You are not allowed to modify this blog post!' unless current_user.can_edit?(@blog)
    end
end
