require 'test/unit'
require 'shoulda'
require 'action_view'
require 'bigdecimal'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'attrtastic'

class TestCase < Test::Unit::TestCase
  def html(string)
    string.split(/\n/m).map(&:strip).join
  end
  def setup_fixtures
    @user = User.new.tap do |u|
      u.first_name,u.last_name = "John","Doe"
      u.email = "john@doe.com"
      u.created_at = DateTime.parse("2011-06-02 12:06:42")
      u.time = Time.at(946702800)
      u.birthday = Date.parse("1953-06-03")
      u.float = 54424.22
      u.decimal = BigDecimal.new('4454.3435')
      u.integer = 45453
    end
    @blog = Blog.new.tap{|b| b.name,b.url,b.author = "IT Pro Blog","http://www.it.pro.blog",@user}
    @blog.posts = [
      Post.new.tap{|p| p.title,p.content = "Hello World!","Hello World!\nInitial post"},
      Post.new.tap{|p| p.title,p.content = "Sorry","Sorry for long delay. Had much stuff on my head..."},
    ]
    @user.blog = @blog

    ActionView::Base.send :include, Attrtastic::SemanticAttributesHelper
    @template = ActionView::Base.new.tap{ |av| av.output_buffer = ActiveSupport::SafeBuffer.new }
    @user_builder = Attrtastic::SemanticAttributesBuilder.new(@user, @template)
    @blog_builder = Attrtastic::SemanticAttributesBuilder.new(@blog, @template)
  end
end

class User
  attr_accessor :first_name, :last_name, :email, :title, :created_at, :time, :birthday, :float, :decimal, :integer, :blog

  def address
    {
      :street => "Hellway 13",
      :city => "New York",
    }
  end

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
