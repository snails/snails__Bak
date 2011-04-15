#encoding: utf-8
class SessionsController < ApplicationController
  #会话控制器，用来保存控制用户的Sessions
  def new
    @title = '登录'
  end

  #用户登录提交处理
  def create
    user = User.authenticate(params[:session][:email],params[:session][:password])

    if user.nil?
      #用户密码或邮箱有错误
      flash[:error] = '邮箱或者密码有错误'
      @title = '登录'
      render 'new'
    else
      #用户登录成功
      sign_in user
      #返回到上次登录前页面或用户首页
      redirect_back_or user
    end
  end

  #用户注销
  def destroy
    sign_out
    redirect_to root_path
  end

end
