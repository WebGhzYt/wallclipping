require 'authenticated_system'
require 'session_loader'
class ApplicationController < ActionController::Base
  before_filter :set_flashes_to_null
  before_filter :add_subcategories

  include AuthenticatedSystem
  include SessionLoader
  protect_from_forgery

    def set_flashes_to_null
    	flash[:error] =  ''
    	flash[:notice] = ''
    end

    def self.hash_tag_action(table, options={})
      model_class = Object.const_get(table.classify)
      define_method(:fetch_hash_tags) do
        hash_tag = lambda do
          begin
        		unless params[:keyword].blank?
              @tags = model_class.search params
            else
        	  	@tags = []
          	end
          rescue
            @tags = []
          end
        end
        hash_tag.call
      end
    end

    def add_subcategories
      @category_1 = SubCategory.where(category: 1)
      @category_2 = SubCategory.where(category: 2)
      @category_3 = SubCategory.where(category: 3)
    end

end
