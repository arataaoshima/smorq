class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: [:edit, :update, :destroy, :new, :create]
  before_action :check_signed_in, only: [:edit, :update, :destroy, :new, :create]
  # GET /blogs
  # GET /blogs.json
  def index
    #@blogs = Blog.all
    @blogs = Blog.search(params[:search]).paginate(page: params[:page], per_page: 12)
    @blog_categories = BlogCategory.all
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show

  end

  # GET /blogs/new
  def new
    @blog = Blog.new
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs
  # POST /blogs.json
  def create
    @blog = Blog.new(blog_params)

    respond_to do |format|
      if @blog.save
        format.html { redirect_to @blog, notice: 'Blog was successfully created.' }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blogs/1
  # PATCH/PUT /blogs/1.json
  def update
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to @blog, notice: 'Blog was successfully updated.' }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.json
  def destroy
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to blogs_url, notice: 'Blog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def blog_params
      params.require(:blog).permit(:title, :content, :video, blog_category_ids: [])
    end

    def check_signed_in
      if !user_signed_in?
        redirect_to root_path
      end
    end

    def check_admin
      if user_signed_in? && current_user.admin != true
        redirect_to root_path
      end
    end


end
