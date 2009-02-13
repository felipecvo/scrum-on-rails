class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  
  before_filter :find_user, 
    :only => [:profile, 
              :destroy, 
              :edit_password,   :update_password, 
              :edit_email,      :update_email ]
  
  layout 'login'
  
  # render new.rhtml
  def new
    @user = User.new
  end

  def troubleshooting
    # Render troubleshooting.html.erb
    render :layout => 'login'
  end

  def clueless
    # These users are beyond our automated help...
    render :layout => 'login'
  end

  def forgot_login    
    if request.put?
      begin
        @user = User.find_by_email(params[:email], :conditions => ['NOT state = ?', 'deleted'])
        
        if ! @user.not_using_openid?
          flash[:notice] = "You cannot help you, you're using OpenID!"
          redirect_to :back
        end
      rescue
        @user = nil
      end
      
      if @user.nil?
        flash.now[:error] = 'No account was found with that email address.'
      else
        UserMailer.deliver_forgot_login(@user)
      end
    else
      # Render forgot_login.html.erb
    end
    
    render :layout => 'login'
  end

  def forgot_password    
    if request.put?
      @user = User.find_by_login_or_email(params[:email_or_login])

      if @user.nil?
        flash.now[:error] = 'No account was found by that login or email address.'
      else
        if ! @user.not_using_openid?
          flash[:notice] = "You cannot reset your password here. You are using OpenID!"
          redirect_to :back
        else
          @user.forgot_password if @user.active?
        end
      end
    else
      # Render forgot_password.html.erb
    end
    
    render :layout => 'login'
  end
  
  def reset_password    
    begin
      @user = User.find_by_password_reset_code(params[:password_reset_code])
    rescue
      @user = nil
    end
    
    unless @user.nil? || !@user.active?
      @user.reset_password!
    end
    
    render :layout => 'login'
  end

  def create
    logout_keeping_session!
    if using_open_id?
      authenticate_with_open_id(params[:open_id_url], :return_to => open_id_create_url,
        :required => [:nickname, :email]) do |result, identity_url, registration|
        if result.successful?
          create_new_user(:identity_url => identity_url, :login => identity_url, :email => registration['email'])
        else
          failed_creation(result.message || "Sorry, something went wrong")
        end
      end
    else
      create_new_user(params[:user])
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to login_path
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default(root_path)
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default(root_path)
    end
  end
  
  def edit_password
    if ! @user.not_using_openid?
      flash[:notice] = "You cannot update your password. You are using OpenID!"
      redirect_to :back
    end
    
    # render edit_password.html.erb
  end
  
  def update_password    
    if ! @user.not_using_openid?
      flash[:notice] = "You cannot update your password. You are using OpenID!"
      redirect_to :back
    end
    
    if current_user == @user
      current_password, new_password, new_password_confirmation = params[:current_password], params[:new_password], params[:new_password_confirmation]
      
      if @user.encrypt(current_password) == @user.crypted_password
        if new_password == new_password_confirmation
          if new_password.blank? || new_password_confirmation.blank?
            flash[:error] = "You cannot set a blank password."
            redirect_to edit_password_user_url(@user)
          else
            @user.password = new_password
            @user.password_confirmation = new_password_confirmation
            @user.save
            flash[:notice] = "Your password has been updated."
            redirect_to profile_url(@user)
          end
        else
          flash[:error] = "Your new password and it's confirmation don't match."
          redirect_to edit_password_user_url(@user)
        end
      else
        flash[:error] = "Your current password is not correct. Your password has not been updated."
        redirect_to edit_password_user_url(@user)
      end
    else
      flash[:error] = "You cannot update another user's password!"
      redirect_to edit_password_user_url(@user)
    end
  end
  
  def edit_email
    if ! @user.not_using_openid?
      flash[:notice] = "You cannot update your email address. You are using OpenID!"
      redirect_to :back
    end
    
    # render edit_email.html.erb
  end
  
  def update_email
    if ! @user.not_using_openid?
      flash[:notice] = "You cannot update your email address. You are using OpenID!"
      redirect_to :back
    end
    
    if current_user == @user
      if @user.update_attributes(:email => params[:email])
        flash[:notice] = "Your email address has been updated."
        redirect_to profile_url(@user)
      else
        flash[:error] = "Your email address could not be updated."
        redirect_to edit_email_user_url(@user)
      end
    else
      flash[:error] = "You cannot update another user's email address!"
      redirect_to edit_email_user_url(@user)
    end
  end  
  
  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    current_user.delete!
    
    logout_killing_session!
    
    flash[:notice] = "Your account has been removed."
    redirect_back_or_default(root_path)
  end  
  
  protected

  def find_user
    @user = User.find(params[:id])
  end

  def create_new_user(attributes)
    @user = User.new(attributes)
    if @user && @user.valid?
      if @user.not_using_openid?
        @user.register!
      else
        @user.register_openid!
      end
    end
    
    if @user.errors.empty?
      successful_creation(@user)
    else
      failed_creation
    end
  end
  
  def successful_creation(user)
    redirect_back_or_default(root_path)
    flash[:notice] = "Thanks for signing up!"
    flash[:notice] << " We're sending you an email with your activation code." if @user.not_using_openid?
    flash[:notice] << " You can now login with your OpenID." if ! @user.not_using_openid?
  end
  
  def failed_creation(message = 'Sorry, there was an error creating your account')
    flash[:error] = message
    # @user = User.new
    render :action => :new
  end
end
