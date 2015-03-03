ActiveAdmin.register FaqCategory do
  index do
   column :id do |faqcat|
     span link_to "#{faqcat.id}", admin_faq_category_path(faqcat)
   end
   column "Category" do |faqcat|
     faqcat.category  
   end
   default_actions
 end
  filter :category, :as => :string  
 

   form do |f|                         
    f.inputs "Category" do       
      f.input :category                  
    end                               
    f.actions                         
  end
end
