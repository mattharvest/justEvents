desc "This task is called by Heroku scheduler to mail each user their daily list of todos"
task :email_dailies => :environment do
	puts "Sending daily reports for all users."
	User.email_dailies
	puts "finished dailies."
end