class UsersController < ApplicationController
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @user = User.find(params[:id])
    @infos = @user.infos.order(:category)
    @projects = @user.projects

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def resume
    @user = User.find(params[:id])
    @infos = @user.infos.order(:category)
    @projects = @user.projects

    respond_to do |format|
      format.html
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

  def update_by_github
    @user = User.find(params[:id])
    information ||= Octokit.user(@user.github_name)
    generate_infos(@user, information)
    generate_skills(@user, information)
    generate_projects(@user, information)

    respond_to do |format|
      format.html { redirect_to @user }
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

    def generate_infos(user, information)
      user.name = information.name
      user.infos.find_or_create_by_title_and_category("avatar_url", "per_info", :content => information.avatar_url) if information.avatar_url
      user.infos.find_or_create_by_title_and_category("html_url", "per_info", :content => information.html_url) if information.html_url
      user.infos.find_or_create_by_title_and_category("company", "per_info", :content => information.company) if information.company
      user.infos.find_or_create_by_title_and_category("blog", "per_info", :content => information.blog) if information.blog
      user.infos.find_or_create_by_title_and_category("location", "per_info", :content => information.location) if information.location
      user.infos.find_or_create_by_title_and_category("email", "per_info", :content => information.email) if information.email
      user.infos.find_or_create_by_title_and_category("public_repos", "per_info", :content => information.public_repos) if information.public_repos
      user.infos.find_or_create_by_title_and_category("public_gists", "per_info", :content => information.public_gists) if information.public_gists
      user.infos.find_or_create_by_title_and_category("followers", "per_info", :content => information.followers) if information.followers
      user.infos.find_or_create_by_title_and_category("following", "per_info", :content => information.following) if information.following
      user.save!
    end

    # http://developer.github.com/guides/rendering-data-as-graphs/
    def generate_skills(user, information)
      language_obj = {}
      url = information.repos_url
      response = RestClient.get url
      repositories = JSON.parse response.body
      repositories.each do |repo|
        if repo['language']
          if !language_obj[repo['language']]
            language_obj[repo['language']] = 1
          else
            language_obj[repo['language']] += 1
          end
        end
      end
      lan_sum = language_obj.values.sum
      language_obj.each do |k, v|
        user.infos.find_or_create_by_title_and_category(k, "skills", :content => (v*100/lan_sum).to_s+"%")
      end
    end

    def generate_projects(user, information)
      url = information.repos_url
      response = RestClient.get url
      repositories = JSON.parse response.body
      repositories.each do |repo|
        user.projects.find_or_create_by_name_and_url(repo['name'], repo['git_url'],
                                                    :created_at => repo['created_at'],
                                                    :finished_at => repo['updated_at'],
                                                    :introduction => repo['description'])
      end
    end
end
