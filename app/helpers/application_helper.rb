module ApplicationHelper

	def title
		base_title = "justEvents"
		if @title.nil? 
			base_title 
		else
			"#{base_title} | #{@title}"
		end
	end
	
	def user_list
		Users.find(:all)
	end
	
	def current_user_users

	end
	
	def juvenile_categories
		{
			'screening' => 'screening',
			'continuance' => 'continuance',
			'writ' => 'writ',
			'merits hearing' => 'trial',
			'plea deal (incl. stet)' => 'plea',
			'decline to prosecute' => 'dtp',
			'acquittal' => 'acquittal',
			'dismissal' => 'dismissal',
			'waiver-up' => 'waiver up',
			'waiver-down' => 'waiver down',
			'restitution hearing'=> 'restitution hearing',
			'to do'=>'todoitem',
			'phonecall'=>'phonecall',
			'investigation'=>'investigation',
			'email'=>'email'
		}
	end
	def grandjury_categories
		{
		'screening' => 'screening',
		'charged' => 'charged',
		'returned for investigation' => 'RFI',
		'declined to prosecute' => 'dtp',
		'investigation'=>'investigation',
		'email'=>'email'
		}
	end
	def circuit_categories
		{
		'preliminary hearing'=>'ph',
		'sent to district court'=>'dcwl',
		'screening'=>'screening',
		'trial'=>'trial',
		'plea deal (incl. stet)'=>'plea',
		'nolle prosequi'=>'dtp',
		'acquittal'=>'acquittal',
		'bench warrant'=>'bench warrant',
		'other'=>'other',
		'Broadcast Notice'=>'notice',
		'NCIC'=>'NCIC',
		'search warrant'=>'search warrant',
		'subpoeana issued'=>'subpoena issued',
		'waiver down to juvenile'=>'waiver down',
		'to do'=>'todoitem',
		'phonecall'=>'phonecall',
		'referred to Strategic Investigations'=>'referred to SI',
		'investigation'=>'investigation',
		'email'=>'email'
		}
	end
	
	def community_categories
		{
		'community need identified'=>'community need identified',
		'suspect assigned to attorney'=>'assigned',
		'investigation'=>'investigation',
		'email'=>'email'
		}
	end
	
	def postconviction_categories
		{
		'corum nobias' => 'corum nobis',
		'appeal filed' => 'appeal filed',
		'appeal rejected' => 'appeal rejected',
		'verdict overturned' => 'verdict overturned',
		'investigation'=>'investigation',
		'violation reported'=>'violation reported',
		'violation hearing'=>'violation hearing',
		'email'=>'email'
		} 
	end
	
	def strategicinvestigation_categories
		{
		'suspect suggested'=>'new suspect',
		'suspect rejected'=>'suspect rejected',
		'suspect accepted'=>'suspect accepted',
		'case assigned'=>'case assigned',
		'investigation'=>'investigation',
		'email'=>'email'
		}
	end
	
	def post_categories
		list = {}
		if current_user.unit.eql?("juvenile")
			list=juvenile_categories.sort
		elsif current_user.unit.eql?("grand jury")
			list=grandjury_categories.merge(circuit_categories).sort
		elsif current_user.unit.eql?("community prosecution")
			list=community_categories.merge(circuit_categories).sort
		elsif current_user.unit.eql?("postconviction")
			list=postconviction_categories.merge(circuit_categories).sort
		elsif current_user.unit.eql?("strategic investigation")
			list=strategicinvestigation_categories.merge(circuit_categories).sort
		else
			list=circuit_categories.sort
		end
		list
	end
	
end
