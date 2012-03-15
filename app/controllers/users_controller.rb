class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    add_breadcrumb("All Users")
    
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    add_breadcrumb("User Info")

    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    add_breadcrumb("New User")

    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    add_breadcrumb("Edit User")

    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save
        #puts  "GG" + @user.errors.inspect
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      ## GG enables user attribute edit screen update without forcing the user to enter their password on save
      if @user.update_without_password(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end


 def make_admin
    @user = User.find( params[:id] ) || current_user
    @user.admin = :true
    @user.save

    respond_to do |wants|
      flash[:notice] = 'User was successfully updated.'
      wants.html { redirect_to :action => "edit", :id => @user.id }
    end
  end

  def remove_admin
    @user = User.find( params[:id] ) || current_user
    @user.admin = :false
    @user.save
    #rent_user, "ADMIN", "admin_privs_remove", ""

    respond_to do |wants|
      flash[:notice] = 'User was successfully updated.'
      wants.html { redirect_to :action => "edit", :id => @user.id }
    end
  end



end
