class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = current_user.comments.build(comment_params)

    respond_to do |format|
      if @comment.save
        format.html do
          # @users = User.all

          # # Twilio constants – should be moved to config
          # account_sid = 'ACd619abfb51473fa45265088dbf7cbf7d'
          # account_token = 'a5225b03b9cfee05ffcf539bf58c6492'

          # @twilio_client = Twilio::REST::Client.new account_sid, account_token

          # @users.each do |user|
          #   @twilio_client.account.sms.messages.create(
          #     :from => '+16463621414',
          #     :to => user.phone_number,
          #     :body => "#{current_user.name} just commented on a collude post."
          #   )
          #   logger.info "Text message sent to #{user.name} at #{user.phone_number}."
          # end
          redirect_to root_path, notice: 'Comment was successfully created.'
        end 
        format.json { render action: 'show', status: :created, location: @comment }
      else
        format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:text, :post_id)
    end
end
