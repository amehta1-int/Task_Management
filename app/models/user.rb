class User < ApplicationRecord
    has_secure_password   #bcrypt- Rails expects users table to have a password_digest column. This is where hashed password is stored. Automatic hashing: When you assign user.password = "secret", Rails automatically hashes it with bcrypt and stores the result in password_digest.
  
    has_many :tasks, dependent: :destroy
  
    before_validation :normalize_email  #callback
  
    validates :name, presence: true
  
    validates :email,
              presence: true,
              uniqueness: { case_sensitive: false },  #ensures no 2 users have the same email id, ignoring tha case. So aaditya@gmail.com and Aaditya@gmail.com are the same
              format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "must look like an email address" }
  
    validates :password, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }  #Validate password length only when creating a new record (new_record?) or when updating an exisiting record
  
    private
  
    def normalize_email
      self.email = email.to_s.strip.downcase
    end
  end
  