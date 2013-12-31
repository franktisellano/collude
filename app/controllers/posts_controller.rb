class PostsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.order('posts.created_at DESC').all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @autofill = (params[:url]) ? true : false
    @tags = Post.tag_counts.map(&:name)
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    @tags = Post.tag_counts.map(&:name)
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
    if @post.save
      format.html do

        @users = User.all

        # Twilio constants – should be moved to config
        account_sid = 'ACd619abfb51473fa45265088dbf7cbf7d'
        account_token = 'a5225b03b9cfee05ffcf539bf58c6492'

        @twilio_client = Twilio::REST::Client.new account_sid, account_token

        @users.each do |user|
          unless user = current_user
            @twilio_client.account.sms.messages.create(
              :from => '+16463621414',
              :to => user.phone_number,
              :body => "#{current_user.email} just created a new post on collude: #{post_url(@post)}"
            )
          end
        end
        redirect_to @post, notice: 'Post was successfully created.'
      end
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  def tagged
    @posts = Post.tagged_with(params[:tag])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:url, :title, :description, :tag_list)
    end
end
