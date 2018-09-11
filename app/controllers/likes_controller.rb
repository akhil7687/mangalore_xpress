class LikesController < ApplicationController

  def find_likeable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.friendly.find(value)
      end
    end
  end

  def toggle
    @like_params = { likeable_id: params[:object_id],
                               likeable_type: params[:object_type],
                               user_id: current_user.id }
    @like = Like.find_by(@like_params)
    if @like.present?
      @like.destroy
    else
      Like.create(@like_params)
    end
    render json: { status: "ok" }
  end

  def index
    @likeable = find_likeable
    respond_to do |format|
      format.js
    end
  end
end
