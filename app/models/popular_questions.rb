class PopularQuestions
  include Mongoid::Document
  #embeds_many :faq_categories, validate: false
  field :question, type: String
  field :answer, type: String
  field :category, type: String
end
