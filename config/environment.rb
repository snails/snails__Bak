# Load the rails application
# 修改记录
# 2011.4.13 添加邮箱配置
# 2011.4.15 添加HOST变量，方便发送邮件
require File.expand_path('../application', __FILE__)

HOST = 'http://www.fightingsnail.com'
# Initialize the rails application
#配置邮箱内容 Modified At 2011.4.13
ActionMailer::Base.delivery_method = :smtp #发送协议
ActionMailer::Base.smtp_settings = { #服务器配置
  :address => 'smtp.gmail.com', #google的smtp
  :port => 587,  #端口号
  :domain => 'www.fightingsnail.com', #发送域名
  :user_name => 'godhuyang', #账户名
  :password => 'xiaoyaozi', #密码
  :authentication => 'plain' ,#验证类型
  :enable_starttls_auto => true #开启安全连接
}

#初始化程序
Snail::Application.initialize!
