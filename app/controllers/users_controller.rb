class UsersController < ApplicationController
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, :notice => I18n.t("flash.actions.create.notice") }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @user = User.find(params[:id])
    user = delete_password(params[:user])

    if @user.id == current_user.id
      flag = 1
    end

    respond_to do |format|
      if @user.update_attributes(user)
        if flag ==1
          sign_in(@user, :bypass => true)
        end
        format.html { redirect_to @user, :notice => I18n.t("flash.actions.update.notice") }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end

  private
    def delete_password(user)
     if user[:password].empty? && user[:password_confirmation].empty?
       user.delete(:password)
       user.delete(:password_confirmation)
     end
     return user
    end
end
