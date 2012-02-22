namespace :db do
	desc "Fill database with original data"
	task :populate => :environment do
		Rake::Task['db:reset'].invoke
		admin = User.create!(:name => "Matthew Bohrer",
                         :email => "msbohrer@co.pg.md.us",
                         :password => "2huyidar",
                         :password_confirmation => "2huyidar",
						 :unit => "juvenile")
		admin.toggle!(:admin)
		mattwatt = User.create!(:name=> "Matthew Watt",
						:email=>"mcwatt@co.pg.md.us",
						:password => "foobar",
						:password_confirmation => "foobar",
						:unit => "administrator")
		mattwatt.toggle!(:admin)
  end
end