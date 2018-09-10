class WallPostsController < ApplicationController
  before_action :set_wall_post, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user! ,:except=>[:index,:show]

  # GET /feeds/1
  # GET /feeds/1.json
  def show
  end

  # GET /feeds/new
  def new
    @wall_post = WallPost.new
  end

  # GET /feeds/1/edit
  def edit
  end


  # POST /feeds
  # POST /feeds.json
  def create
    @wall_post = WallPost.new(wall_post_params)
    @wall_post.user = current_user
    respond_to do |format|
      if @wall_post.save
        format.html { redirect_to @wall_post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @wall_post }
      else
        format.html { render :new }
        format.json { render json: @wall_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feeds/1
  # PATCH/PUT /feeds/1.json
  def update
    respond_to do |format|
      if @wall_post.update(wall_post_params)
        format.html { redirect_to @wall_post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @wall_post }
      else
        format.html { render :edit }
        format.json { render json: @wall_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @wall_post.destroy
    respond_to do |format|
      format.html { redirect_to wall_posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wall_post
      if current_user.is_admin?
        @wall_post = WallPost.find(params[:id])
        return
      end
      @wall_post = current_user.wall_posts.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to(root_path, :notice => 'You are not authorized for this action')
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wall_post_params
      params.require(:feed).permit(:photo, :description, :status,:user_id)
    end
end
