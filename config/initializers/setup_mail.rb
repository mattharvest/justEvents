ActionMailer::Base.smtp_settings = {
	:address				=> "smtp.gmail.com",
	:port					=> 587,
	:user_name				=> "matthew.bohrer@gmail.com",
	:password				=> "colexander",
	:authentication			=> "plain",
	:enable_starttls_auto 	=> true
}

ActionMailer::Base.default_url_options[:host] = "http://justevents.heroku.com"