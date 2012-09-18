class UserMailer < ActionMailer::Base
	
	default :from => "pgsao.justevents@gmail.com"
	def registration_confirmation(user, password)
		@user = user
		@password = password
		mail(:to=> user.email, :subject => "Registered with justEvents")
	end
	
	def verify_mail_settings
		mail(:to=>"matthew.bohrer@gmail.com", :subject=>"verifying mail settings")
	end
	
	def dtp_notice(user, post)
		@user=user
		@post=post
		#
		mail(:to=>"yacunningham@co.pg.md.us", :cc=>@user.email, :subject=>"DTP: "+@post.casenumber+" "+@post.defendant)
	end
	
	def test_calendar
		mail(:to=> "matthew.bohrer@gmail.com", :subject=>"testing iCalendar") do |format|
				format.ics {
					event = Icalendar::Event.new
					event.start = Date.today
					event.end = Date.tomorrow
					event.summary = "Test summary"
					event.description = "Test description"
					event.location = "Test location"
					event.uid = "Test UID"
					
					calendar = Icalendar::Calendar.new
					calendar.add_event(event)
					calendar.publish
					render :text => calendar.to_ical
				}
			end
	end
	
	def daily_report(user, todos)
		@user = user
		@todos=todos
		mail(:to=> @user.email, :subject=>"Daily report")
	end
	
	def todo_notice(todoitem, recipient, sender)

		@user = recipient
		@sender = sender
		@todoitem=todoitem
		@content = @todoitem.content
		@casenumber = @todoitem.casenumber
		
			mail(:from=>@sender.email, :to=> @user.email, :subject=>@casenumber.to_s+"-TODO: "+@content) do |format|
				format.ics {
					event = Icalendar::Event.new
					event.dtstart = @todoitem.duedate
					event.dtstart.ical_params = { "VALUE" => "DATE" }
					event.dtend = @todoitem.duedate+1
					event.dtend.ical_params = { "VALUE" => "DATE" }

					event.summary = @todoitem.content #TITLE
					event.description = @todoitem.content #BODY
					event.location = "Upper Marlboro"
					event.uid = "TODOITEM-"+@user.email+"-"+@todoitem.id.to_s+rand().to_s
					
					calendar = Icalendar::Calendar.new
					calendar.add_event(event)
					calendar.publish
					render :text => calendar.to_ical
				}
			end
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
	
	def investigation_notice(assignor, user, investigation, notifications)
		@user = user
		@assignor=assignor
		@investigation=investigation
		mail(:to=> @user.email, :subject => "New Investigation assigned to "+@user.name+" in "+@investigation.casenumber, :cc=> notifications)
	end
	
	def casefile_notice(user, assignee, casefile, notifications)
		@casefile = casefile
		@user=user
		@assignee=assignee

		mail(:to=>notifications, :subject=>"Casefile created: "+@casefile.lead_casenumber)
	end
	
	def petition_notice(petition, user)
		@petition=petition
		@user=user
		mail(:subject=>@petition.ccn+" - "+@petition.defendant, :cc=>@user.email, :to=>@petition.email_address)
	end
end
