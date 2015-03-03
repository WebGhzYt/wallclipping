class HashTag
  include Mongoid::Document
  include Mongoid::Timestamps


  field :name, :type => String

  include Tire::Model::Search
  include Tire::Model::Callbacks


  mapping do
    indexes :name, type: 'string'
  end

  def to_indexed_json
      to_json(methods: [:name], except: [:_id,:created_at,:updated_at])
  end

  def self.search(params)
    tire.search( :load => true) do
      query do
         boolean do
           must { string "#{params[:keyword].gsub("#","")}*", default_operator: "OR" }
         end
      end
      sort { by :name, 'ASC' }
      page = params[:page].present? ? params[:page].to_i : 1
      search_size = 10
      from (page - 1) * search_size
      size search_size
    end
  end
end
