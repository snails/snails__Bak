#encoding: utf-8
module SessionsHelper
  #保存Cookie
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt ]
    current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  #当前用户为当前的，如果当前为空，则返回Cookie中 保存的用户
  def current_user
    @current_user ||= user_from_remember_token
  end

  #用户是否已登录
  def signed_in?
    !current_user.nil?
  end

  #注销
  def sign_out
    cookies.delete(:remember_token)
    current_user = nil
  end

  #保存用户登录前的页面，如果用户没有登录
  def deny_access
    store_location
    redirect_to signin_path, :notice => '请先进行登录，再进行操作'
  end
  
  #用户所在页面的用户是否是当前用户
  def current_user?(user)
    user == current_user
  end

  #返回到某个页面
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  private
    #使用cookies或者用户登录信息进行用户有效性
    def user_from_remember_token
      #*表示允许二个元素组成参数
      User.authenticate_with_salt(*remember_token)
    end
    
    #注册cookies
    def remember_token
      cookies.signed[:remember_token] || [nil,nil]
    end

    #清除要返回的页面信息
    def clear_return_to
      session[:return_to] = nil
    end

    #存储用户返回的页面
    def store_location
      session[:return_to] = request.fullpath
    end
  
    #对用户是否登录进行校验
    def authenticate 
      deny_access unless signed_in?
    end


end
