class CasefilesController < ApplicationController
  def new
	@casefile = current_user.casefiles.build(params[:casefile])
	@casefile.save
  end
end
