ActiveAdmin.register MoreReasonPopup do

    index do
      column :more_reason_popup_image
      default_actions
    end 

    form do |f|
        f.inputs "More Reason Popup Image" do
          f.input :more_reason_popup_image
        end
        f.buttons
    end

end
