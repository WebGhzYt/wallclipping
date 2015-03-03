if FeedType.count > 1
	FeedType.destroy_all
end

FeedType.create(:post_type => "Status")
FeedType.create(:post_type => "File")
#FeedType.create(:post_type => "Video")
FeedType.create(:post_type => "Event")
FeedType.create(:post_type => "Deal")


emtp1 = EmotionType.create(:name => "Positive emotions")

# Emotion.create(:name => "Stylish", :order => 0, active: true )
# Emotion.create(:name => "Overwhelming",:order => 1, active: true)
# Emotion.create(:name => "Creative", :order => 2, active: true)
# Emotion.create(:name => "Informative",:order => 3, active: true)
# Emotion.create(:name => "Authentic", :order => 4, active: true)
# Emotion.create(:name => "Luxurious", :order => 5, active: true)

if Emotion.count > 1
	Emotion.destroy_all
end

Emotion.create(:name => "Black", :order => 0, active: true )
Emotion.create(:name => "Blue", :order => 1, active: true)
Emotion.create(:name => "Green", :order => 2, active: true)
Emotion.create(:name => "Red", :order => 3, active: true)
Emotion.create(:name => "White", :order => 4, active: true)
Emotion.create(:name => "Yellow", :order => 5, active: true)

#Emotion.create(:name => "Superb", :emotion_image => "/img/Emotions/New/0new_heart_off.png", :order => 0, active: true )
#Emotion.create(:name => "Outstanding", :emotion_image => "/img/Emotions/New/1new_heart_off.png", :order => 1, active: true)
#Emotion.create(:name => "Classy", :emotion_image => "/img/Emotions/New/2new_heart_off.png", :order => 2, active: true)
#Emotion.create(:name => "Inspires", :emotion_image => "/img/Emotions/New/3new_heart_off.png", :order => 3, active: true)
#Emotion.create(:name => "Adorable", :emotion_image => "/img/Emotions/New/4new_heart_off.png", :order => 4, active: true)
#Emotion.create(:name => "Like", :emotion_image => "/img/Emotions/New/5new_heart_off.png", :order => 5, active: true)

if SubCategory.count > 1
	SubCategory.destroy_all
end

# sub_categories = ['Book', 'Games', 'Film', 'Music', 'Sports', 'Travel'],
# 				  ['Beauty', 'Clothing', 'Eyewear', 'Footwear', 'Home Decor', 'Jewelry'],
# 				  ['Celebration', 'Faith', 'Health', 'Parenting', 'Recipies', 'Relationships']

sub_categories = ['Status', 'Jokes', 'Memories', 'Politics', 'Questions','Anything Else'],
				  ['Apps & Games', 'Fashion', 'Food & Drinks', 'Outdoors', 'Music & Movies', 'Something Else'],
				  ['Auto', 'Electronics', 'Furnishings', 'Jobs', 'Real Estate', 'Everything Else']
				

sub_categories.each_with_index do |sc, index|
	sc.each do |name|
		SubCategory.create(name: name, category: index+1, icon: "/assets/SubCategory/#{index+1}/#{name}.png")
	end
end