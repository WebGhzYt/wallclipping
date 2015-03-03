class FaqCategory
  include Mongoid::Document
  #embedded_in :popular_question
  field :category, type: String
end
