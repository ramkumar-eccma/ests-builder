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

  # User Approval by admin
  # def active_for_authentication? 
  #   super && approved? 
  # end 

  # def inactive_message 
  #   if !approved? 
  #     :not_approved 
  #   else 
  #     super # Use whatever other message 
  #   end 
  # end   

  # after_create :send_admin_mail
  # def send_admin_mail
  #   AdminMailer.new_user_waiting_for_approval(self).deliver
  # end

  # def self.send_reset_password_instructions(attributes={})
  #   recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
  #   if !recoverable.approved?
  #     recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
  #   elsif recoverable.persisted?
  #     recoverable.send_reset_password_instructions
  #   end
  #   recoverable
  # end

  # def disapprove 
  #   self.approved = false 
  # end 
  # def approve 
  #   self.approved = true 
  # end 
  # def active_for_authentication? 
  #   super && approved? 
  # end 
  # def inactive_message 
  #   approved? ? super : "Your account has not been approved" 
  # end 
    
end
