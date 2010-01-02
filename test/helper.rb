require 'test/unit'
require 'action_view'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'attrtastic'

class Test::Unit::TestCase
  def html(string)
    string.split(/\n/m).map(&:strip).join
  end
  def setup_fixtures
    @user = User.new.tap do |u|
      u.first_name,u.last_name = "John","Doe"
      u.email = "john@doe.com"
    end
    @blog = Blog.new.tap{|b| b.name,b.url,b.author = "IT Pro Blog","http://www.it.pro.blog",@user}
    @blog.posts = [
      Post.new.tap{|p| p.title,p.content = "Hello World!","Hello World!\nInitial post"},
      Post.new.tap{|p| p.title,p.content = "Sorry","Sorry for long delay. Had much stuff on my head..."},
    ]

    ActionView::Base.send :include, Attrtastic::SemanticAttributesHelper
    @template = ActionView::Base.new.tap{ |av| av.output_buffer = "" }
    @user_builder = Attrtastic::SemanticAttributesBuilder.new(@user, @template)
    @blog_builder = Attrtastic::SemanticAttributesBuilder.new(@blog, @template)
  end
end

class User
  attr_accessor :first_name, :last_name, :email

  def full_name
    [last_name,first_name].join(", ")
  end
end

class Blog
  attr_accessor :name, :url, :author, :posts
  delegate :full_name, :to => :author, :prefix => true
end

class Post
  attr_accessor :title, :content
end
