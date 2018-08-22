class ContestsController < ApplicationController
  before_action :set_contest, only: [:show, :edit, :update, :destroy]

  def index
    @contests = Contest.all
    respond_to do |format|
      format.html
    end
  end

  def new
    @contest = Contest.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @contest = Contest.new(contest_params)
    @contest.save
    redirect_to contests_path
    respond_to do |format|
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    @contest.update(contest_params)
    redirect_to contests_path
    respond_to do |format|
      format.html
    end
  end


  def destroy
    @contest.destroy
    redirect_to contests_path
    respond_to do |format|
      format.html
    end
  end

  private
  def set_contest
    @contest = Contest.find(params[:id])
  end

  def contest_params
    params.require(:contest).permit(:name,:pic,:status,:btn_text)
  end
end
