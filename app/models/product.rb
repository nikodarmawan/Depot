class Product < ActiveRecord::Base
    default_scope :order => 'title'
    
    validates :title, :description, :image_url, :presence => true
    validates :price, :numericality => {:greater_than_or_equal_to => 0.01 }
    validates :title, :uniqueness => true
    validates :image_url, :format =>{
        :with => %r{\.(gif|jpg|png|jpeg)}i,
        :message => "must be URL for GIF,JPG,JPEG, or PNG image."
    }
    validates :title, :length => {:minimum =>10}
    
    
end
