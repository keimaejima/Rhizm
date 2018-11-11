class UserMailer < ApplicationMailer
	default from: Settings.email.info

  	def welcome_email(user)
  	  @user = user
  	  mail(to: @user.email, subject: 'ご登録いただきありがとうございます')
  	end
end
