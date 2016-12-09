class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable
   
  #protected  its is for skip the mail confirmation
  def confirmation_required?
    false
  end
  
  # Validation Purpose
  validates :email, :password, presence: true
  validates :email, uniqueness: true
  
  # Password Complexity
  validate :password_complexity
  def password_complexity
    return unless password.present?
    errors.add :password, "must include at least one lower case letter." unless password =~ /[a-z]/
    errors.add :password, "must include at least one upper case letter."  unless password =~ /[A-Z]/
    errors.add :password, "must include at least one digit." unless password =~ /[\d]/
    errors.add :password, "must include at least one special character." unless password =~ /[\W]/
  end
end
