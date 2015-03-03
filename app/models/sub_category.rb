class SubCategory
  include Mongoid::Document

  has_many :feeds

  field :name, type: String
  field :category, type: Integer
  field :icon, type: String

  def self.named_category(category_value)
  	case category_value
  	when 1
  		"Activities"
  	when 2
  		"Interests"
  	when 3
  		"Classifieds"
  	end
  end
end

