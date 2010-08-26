require 'test_helper'

class DocumentTest < ActiveSupport::TestCase

  belong_to :author
  belong_to :meta_definition


  context "A existing Document instance" do
    setup do
      @blog = Document['blog']
    end

    should "have posts" do
      assert_nothing_raised do
        @blog.posts
      end
    end

    should "not have a parent" do
      assert_nil @blog.parent
    end
  end

  context "A new Document instance" do
    setup do
      @document = Document.new
      @document.meta_definition = MetaDefinition.first
    end

    should "not need a meta definition yet" do
      assert_nothing_raised do
        @document.permalink
      end
    end

    should "not save without required fields" do    
      assert !@document.save
    end
  end

  
end