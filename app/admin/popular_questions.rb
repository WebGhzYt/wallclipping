ActiveAdmin.register PopularQuestion do
  index do
   column :id do |pq|
     span link_to "#{pq.id}", admin_popular_question_path(pq)
   end
   column "Question" do |pq|
     pq.question  
   end
   column "Answer" do |pq|
     pq.answer
   end
   column "Category" do |pq|
     pq.category
   end
   default_actions
 end
  filter :question, :as => :string  
  filter :answer, :as => :string  

   form do |f|                         
    f.inputs "Questions & Answers" do       
      f.input :question                  
      f.input :answer 
      f.input :category, :label => 'category', :as => :select, :collection => FaqCategory.all.map{|u| ["#{u.category}", u.category]}
    end                               
    f.actions                         
  end
end
