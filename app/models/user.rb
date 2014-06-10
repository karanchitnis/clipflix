class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :provider, :uid, :oauth_token, :oauth_expires_at, :num_vids
  
  #has_secure_password
  attr_accessor :password
  before_save :encrypt_password
  validates_confirmation_of :password

  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name: "Relationship",
                                   dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :playlists
  has_many :searches

  before_save { |user| user.email = user.email.downcase }
  #before_save :create_remember_token

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  #validates :password, length: { minimum: 6 }
  #validates :password_confirmation, presence: true
  acts_as_voter

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at) unless auth.credentials.expires_at.nil?
      user.save!
    end
  end

  def vid_count_inc
    inc = self.num_vids + 1
    self.update_attribute(:num_vids, inc)
  end

  def vid_count_dec
    dec = self.num_vids - 1
    self.update_attribute(:num_vids, dec)
  end

  def vid_count_inc_list(playlist)
    inc = self.num_vids + playlist.videos.count
    self.update_attribute(:num_vids, inc)
  end

  def vid_count_dec_list(playlist)
    inc = self.num_vids - playlist.videos.count
    self.update_attribute(:num_vids, inc)
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end