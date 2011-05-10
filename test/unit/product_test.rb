require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  fixtures :products
  
  test "the truth" do
    assert true
  end
  
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any? 
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end
  
  test "Product price must be positive" do
    product = Product.new(:title => "My Book Title",
                    :description => "Desc",
                    :image_url => "book.jpg"
                    )
                
    product.price = -1
    assert product.invalid?, "invalid products"
    assert_equal "must be greater than or equal to 0.01",
        product.errors[:price].join('; ')
        
    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
        product.errors[:price].join('; ')
        
    product.price = 1
    assert product.valid?
  end
  
  test "Title length check" do
      product = Product.new(:title => "My Book",
                      :description => "Desc",
                      :image_url => "book.jpg",
                      :price => 1
                      )
                      
      assert product.invalid?
      assert_equal "is too short (minimum is 10 characters)",
                  product.errors[:title].join("; ")
      
      product.title = "My book with super long title"
      assert product.valid?
    
  end
  
  def new_product(image_url) 
      Product.new(:title =>'Book title',
        :description => 'Description',
        :price => 1,
        :image_url => image_url
      )
  end
  
  test "image url" do
      ok = %w{ fred.gif fred.jpg fred.png fred.jpeg http://a.b.c/d/e.png }
      bad = %w{ fred.tiff fred.more/image fred.wierd}
      
      ok.each do |file|
        assert new_product(file).valid?, "#{file} shouldn't be invalid"
      end
      
      bad.each do |file|
          assert new_product(file).invalid?, "#{file} shouldn't be valid"
      end
  end
  
  test "product is not valid without unique title" do
     product = Product.new(:title => products(:ruby).title,
        :description => "Test",
        :price => 1,
        :image_url =>"image.jpg"
     )
     
     assert !product.save
     assert_equal "has already been taken",product.errors[:title].join('; ')
  end
  
  test "product is not valid without a unique title - i18n" do
      product = Product.new(:title => products(:ruby).title,
          :description => "Test",
          :price => 1,
          :image_url =>"image.jpg"
       )
       assert !product.save
       assert_equal I18n.translate('activerecord.errors.messages.taken'),
       product.errors[:title].join('; ')
  end
  
end
