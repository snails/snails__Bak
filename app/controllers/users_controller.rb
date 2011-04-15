#encoding: utf-8
#修改记录
#2011.4.13 添加用户注册发送激活邮件功能
#2011.4.14 添加用户激活账户和重置密码功能,发送邮件的激活码统一命名为auth_code，不再区分激活与重置的code
require 'digest'

class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @title = '首页'
    @users = User.paginate :page => params[:page],
                            :per_page => 20 #默认每页显示20个用户
      respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @title = @user.name
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @title = '注册新用户'
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @title = '修改信息'
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save
        #添加激活码
        @active_code = @user.active_codes.build(:code =>  Digest::SHA2.hexdigest("#{@user.email}--#{Time.now.utc}")
)
        if @active_code.save 
          #发送激活邮件
          Emailer.confirm(@user,'active').deliver
        end
        #转到个人主页
        format.html { redirect_to(@user, :notice => '用户创建成功，请登录邮箱进行激活.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        @title = '用户注册'
        #清空密码
        @user.password = ''
        @user.password_confirmation = ''
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end


  #用户激活账户
  def active_account
    active_code = params[:auth_code]
    user = valid_user?(active_code)
      if (not user.nil?) && (user.actived == false)
        update_attributes(user)
      else #返回错误，邮箱不存在或激活码已经过期
         flash[:error] = '激活码有误或已经过期'
      end
      redirect_to root_path    
   end

  #用户找回或重置密码,密码丢失后，一律使用重置功能。
  def reset_password
    active_code = params[:auth_code]
    user = valid_user?(active_code)
    unless user.nil? #用户不为空
      redirect_to 'reset_password_user'
    else
      flash[:error] = '激活码有误或已经过期'
    end
    redirect_to root_path
  end

  private
    #根据激活码返回user，否则返回nil
    def valid_user?(auth_code)
      email =  ActiveCode.find_by_sql ["select email from active_codes where code =?",auth_code]
      unless email.blank? #邮箱是有效的
        user = User.find_by_email(emai[0].email)
      end
      return user
    end
end
