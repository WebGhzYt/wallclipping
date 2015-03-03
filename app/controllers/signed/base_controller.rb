class Signed::BaseController < ApplicationController
  
  def check_authentication
    if !current_user
      session[:coming_from] = request.url
      redirect_to root_path
    end
  end

  def sub_category
    sub_categories = []
    categories = SubCategory.all.map { |e| [SubCategory.named_category(e.category), e.category] }
    
    categories.uniq.each do |cat|
      sub_categories << cat[0].split()
    end

    sub_categories.each_with_index do |sc, index|
      sc_array = []
      SubCategory.all.each do |sub_category|
        if SubCategory.named_category(sub_category.category) == sc[0]
          sc_array << [sub_category.name, sub_category.id, {'data-category' => sub_category.category, 'data-icon' => sub_category.icon }] 
        end
      end
      sc << sc_array
    end

    sub_categories
  end
  
end
