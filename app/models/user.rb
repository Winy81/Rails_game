class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  module Role
    ADMIN = 'admin'.freeze
    USER = 'user'.freeze
    ALL = [ADMIN, USER]
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates_presence_of :name
  validates_presence_of :role
  validates_inclusion_of :role, in: Role::ALL

  has_many :characters, dependent: :destroy
  has_one :wallet, dependent: :destroy
  #accepts_nested_attributes_for :wallet

  def self.user_in_asc_id_order
    order(:id => :asc)
  end

  def amount
    self.wallet.amount
  end

end
