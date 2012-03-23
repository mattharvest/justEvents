class UserMailer < ActionMailer::Base
  default from: "matthew.bohrer@gmail.com"
  
	def registration_confirmation(user)
		@user = user
		mail(:to=> user.email, :subject => "Registered with justEvents")
	end
	
	def password_reset(user, password)
		@user = user
		@password = password
		mail(:to=> user.email, :subject => "Password reset")
	end
	
	def call_notice(user, content, casenumber)
		@user = user
		@content = content
		@casenumber=casenumber
		mail(:to=> user.email, :subject => "New call in ("+casenumber.to_s+")")
	end
end
