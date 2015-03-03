ActiveAdmin.register HomeBanner do

    index do
      column :home_banner_image
      default_actions
    end 

    form do |f|
        f.inputs "Home Banner Image" do
          f.input :home_banner_image
        end
        f.buttons
    end

end
