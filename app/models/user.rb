class User < ActiveRecord::Base
	attr_accessor :password
	attr_accessor :registration_code
	attr_accessor :name_comma
	attr_accessor :pending_todos
	attr_accessor :finished_todos
	attr_accessor :supervisor
	attr_accessible :name, :email, :password, :password_confirmation, :unit, :title
	
	has_many :microposts, :dependent => :destroy
	has_many :casefiles
	has_many :todoitems
	
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	
	validates :name, :presence => true
	validates :email, 	:presence => true,
						:format => { :with => email_regex },
						:uniqueness => { :case_sensitive => false }
	validates :password, 	:presence	=> true,
							:confirmation => true,
							:length => { :within => 6..40 }
	validates :registration_code, 	:presence => true,
									:if => :valid_code?
	
	before_save :encrypt_password
	
	def valid_code?
		registration_code=="mattharvest"
	end
	
	def pending_todos
		pending = []
		self.todoitems.each do |t|
			if !t.complete
				pending << t
			end
		end
		pending.sort_by{|t| t[:duedate]}
	end

	def finished_todos
		finished = []
		self.todoitems.each do |t|
			if t.complete
				finished << t
			end
		end
		finished.sort_by{|t| t[:duedate]}
	end
	
	def supervisor?
		(title=="CHIEF")||(title=="DEPUTY")||self.admin?
	end
	
	def to_s
		if title.nil?
			title="ASA" #default value
			self.save
		end
		title+" "+name+" ("+email+") of "+unit
	end
	
	def name_comma
		if !name.nil?
			tokens = name.split(' ')
			tokens.last.to_s+", "+tokens.first.to_s
		else
			name.to_s
		end
	end
	
	def has_password?(submitted_password)
		encrypted_password == encrypt(submitted_password)		
	end
	
	def feed
		microposts
	end
	
	def self.authenticate(email, submitted_password)
		user = find_by_email(email)
		return nil if user.nil?
		return user if user.has_password?(submitted_password)
	end
	
	def self.authenticate_with_salt(id, cookie_salt)
		user = find_by_id(id)
		(user && user.salt == cookie_salt)? user : nil
	end
							
	private
	
		def encrypt_password
			self.salt = make_salt unless has_password?(password)
			self.encrypted_password = encrypt(password)
		end
		
		def encrypt(string)
			string
		end
		
		def make_salt
			secure_hash("#{salt}--#{password}")
		end
		
		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
end
