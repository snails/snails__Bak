#encoding: utf-8
#修改记录
#2011.4.13 添加confirm方法，用来发送邮件
class Emailer < ActionMailer::Base
  default :from => "godhuyang@gmail.com"

  #发送邮件，参数包括用户的信息，在邮箱正文需要显示内容
  def confirm(user,action)
    @user = user
    @url = "#{HOST}/#{action}/"+user.active_codes[0].code
    mail :to => user.email,
         :subject => '激活操作邮件——蜗牛网'
  end
end
