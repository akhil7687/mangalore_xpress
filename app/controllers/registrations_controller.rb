class RegistrationsController < Devise::RegistrationsController

  def create
    if (!honeypot_untouched?)
      flash[:error] = "Failed!"
      redirect_to :back
      return
    end
    super
  end

  protected

  def honeypot_untouched?
    submitted = params['its_so_sweet']
    return false if submitted.blank?
    submitted['email'] == 'john@kdk.in' && submitted['name'] == '' && submitted['agree'].blank?
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_sign_up_path_for(resource)
    profile_path || stored_location_for(resource) || root_path
  end

  def after_update_path_for(resource)
    stored_location_for(resource) || root_path
  end
end
