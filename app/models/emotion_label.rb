class EmotionLabel
	include Mongoid::Document
	include Mongoid::Timestamps
	
	field :emotion_name, :type => String
	field :emotion_order, :type => Integer
  field :user_id, :type => Integer
  
  belongs_to :user

  validates :emotion_name, :presence => true

    def self.get_emotion_name(default_emotion_name,emotion_order,current_user_id)
    	emotion_label = EmotionLabel.where(:emotion_order => emotion_order, :user_id => current_user_id).last
    	if emotion_label
    		emotion_label.emotion_name
    	else
    	  default_emotion_name
    	end    	
    end 	

end 