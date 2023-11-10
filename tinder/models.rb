ActiveRecord::Base.establish_connection 

class User < ActiveRecord::Base
  has_secure_password
  validates :mail, 
    presence: true, 
    format: {with:/\A.+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+\z/}
  validates :password, 
    format: {with:/(?=.*?[a-zA-Z0-9-])(?=.*?[0-9])/},
    length: {in: 0..1000}
  has_many :matches
  has_many :chats
  # belongs_to :settings
  
end 

class Match < ActiveRecord::Base
  belongs_to :users
end 

class Setting < ActiveRecord::Base
  # has_many :users 
end 

class Watching < ActiveRecord::Base
  
end 

class Chat < ActiveRecord::Base
  belongs_to :users
end 