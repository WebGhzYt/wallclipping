class Unsigned::SearchController < Unsigned::BaseController

  before_filter :set_flashes_to_null, :check_authentication

  hash_tag_action 'hash_tags'

  def index
      
  	unless params[:keyword].blank?
      @results = params[:model_type].constantize.search params
    else
  	  @results = []
    end
  end

end
