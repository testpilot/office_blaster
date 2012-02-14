class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable
  # ,
         # :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :votes

  def vote_for(song)
    votes.create(:song => song)
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def full_name=(string)
    self.first_name, self.last_name = string.split(' ', 2)
  end

end
