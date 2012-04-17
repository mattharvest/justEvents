class UserMailer < ActionMailer::Base
  default from: "matthew.bohrer@gmail.com"
  
	def registration_confirmation(user, password)
		@user = user
		@password = password
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
	
	
	def todo_notice(user, content, casenumber)
		@user = user
		@content = content
		@casenumber=casenumber
		mail(:to=> user.email, :subject => "New ToDo in ("+casenumber.to_s+")")
	end
	
	def investigation_notice(assignor, user, investigation, notifications)
		@user = user
		@assignor=assignor
		@investigation=investigation
		mail(:to=> @user.email, :subject => "New Investigation assigned to "+@user.name+" in "+@investigation.casenumber, :cc=> notifications)
	end
	
	def casefile_notice(user, casefile, notifications)
		@casefile = casefile
		@user=user

		mail(:to=>notifications, :subject=>"Casefile created: "+@casefile.lead_casenumber)
	end
end
