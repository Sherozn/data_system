class UserMailer < ApplicationMailer
  default from: "postmaster@xiolu.com"   #也就是域名信息页面Domain Information下面的Default SMTP Login
  def welcome_email(account)
    @account = account
    mail(to: @account.email, subject: '欢迎您来到宠物之家')
  end
end
