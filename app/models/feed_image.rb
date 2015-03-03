class FeedImage
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Rails.application.routes.url_helpers

  belongs_to :feed

  field :feedimage
  mount_uploader :feedimage,FeedImageUploader

  def self.extension_image(file)
    ext =File.extname(file)
    if ext==".pdf"
      "/assets/file_logo/pdf_download.jpg"
    elsif ext == ".doc"
      "/assets/file_logo/docx_download.jpg"
    elsif ext == ".html"
      "/assets/file_logo/html_download.png"
    elsif ext == ".htm"
      "/assets/file_logo/html_download.png"
    elsif ext == ".docx"
      "/assets/file_logo/docx_download.jpg"
    elsif ext == ".txt"
      "/assets/file_logo/txt_download.jpg"
    elsif ext == ".csv"
      "/assets/file_logo/excel_download.jpg"
    elsif ext == ".xls" 
      "/assets/file_logo/xls_download.jpg"      
    else  
    end
  end

end
