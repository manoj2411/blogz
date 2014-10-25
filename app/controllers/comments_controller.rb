class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :set_blog, only: [:create, :new]

  # GET /comments
  # GET /comments.json
  def index
    blog_ids = current_user.blog_ids
    @comments = Comment.where(blog_id: blog_ids)
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new(parent_id: params[:parent_id])
    respond_to do |format|
      format.js { }
    end
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.assign_attributes user: current_user, blog: @blog

    respond_to do |format|
      if @comment.save
        @comments = current_user.is_owner?( @comment.blog) ? @comment.blog.comments.arrange(order: :created_at) : @comment.blog.comments.approved_or_users_owned(current_user).arrange(order: :created_at)
        # format.html { redirect_to @blog, notice: 'Comment was successfully created.' }
        format.js { }
        format.json { render :show, status: :created, location: @comment }
      else
        format.js { render (@comment.root? ? :create : :new)}
        # format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if current_user.is_owner?( @comment.blog )
        if @comment.update(comment_params)
          # format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
          format.js { }
          format.json { render :show, status: :ok, location: @comment }
        else
          # format.html { render :edit }
          format.js { @error = true }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      else
        # format.html { render :edit }
        format.js { @error = 'unauthorised' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #  ===================
  #  = Private methods =
  #  ===================
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_blog
      @blog = Blog.find(params[:blog_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:message, :status, :parent_id)
    end
end
