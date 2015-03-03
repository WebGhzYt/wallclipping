class FaqCategories
  include Mongoid::Document
  #embedded_in :popular_question
  field :category, type: String
end
