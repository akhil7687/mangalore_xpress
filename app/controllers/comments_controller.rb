class CommentsController < ApplicationController


  def find_commentable
    params.each do |name, value|
      name = name.gsub("wallpost","wall_post")
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
  end

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.new comment_params
    @comment.save

    respond_to do |format|
      format.js
    end

  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.js
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body,:user_id)
  end

end
