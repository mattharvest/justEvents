ActionMailer::Base.smtp_settings = {
	:address				=> "smtp.gmail.com",
	:port					=> 587,
	:user_name				=> "pgsao.justevents@gmail.com",
	:password				=> "2huyidar",
	:authentication			=> "plain",
	:enable_starttls_auto 	=> true
}

ActionMailer::Base.default_url_options[:host] = "http://justevents.heroku.com"