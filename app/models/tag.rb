class Tag < ActiveRecord::Base
	has_and_belongs_to_many :microposts
	attr_accessible :name
	
	validates :name, :presence => true
	
	def create
	end
	
	def destroy
	end
end
