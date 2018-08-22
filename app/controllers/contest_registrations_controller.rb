class ContestRegistrationsController < ApplicationController
  before_action :set_contest_registration, only: [:show, :edit, :update, :destroy]

  def index
    @contest_registrations = ContestRegistration.all
    respond_to do |format|
      format.html
    end
  end

  def new
    @contest = Contest.where("id=?",params[:contest_id]).take
    @contest_registration = ContestRegistration.new
    @contest_registration.contest_id = @contest.id
    respond_to do |format|
      format.html
    end
  end

  def create
    flash[:success] = "Thank You For Registring!"
    @contest_registration = ContestRegistration.new(contest_registration_params)
    @contest_registration.save
    cookies[:registered_contest] = @contest_registration.contest_id
    redirect_to cards_path
    respond_to do |format|
      format.html
    end
  end

  def destroy
    @contest_registration.destroy
    redirect_to contest_registrations_path
    respond_to do |format|
      format.html
    end
  end

  private
  def set_contest_registration
    @contest_registration = ContestRegistration.find(params[:id])
  end

  def contest_registration_params
    params.require(:contest_registration).permit(:name,:email,:phone,:contest_id)
  end
end
