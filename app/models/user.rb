class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # user has the ability to join many bands and only has the ability to upload
  # one photo - the avatar
  has_one_attached :photo
  # has_many :genres, through: :user_genres
  # has_many :instruments, through: :user_instruments

  validates :first_name, :last_name, :location, :bio, presence: true
  validates :email, confirmation: true, uniqueness: true
  validates :first_name, :last_name, length: { maximum: 16 }
  validates :bio, length: { maximum: 1000 }
  # validates :instrument, inclusion: { in: %w[Guitar Drums Piano Bass Vocals Violin Cello Flute] }
  validates :genre, inclusion: { in:
    ['Rock', 'Jazz', 'Alternative', 'RnB', 'Hip-Hop', 'Heavy Metal', 'Country', 'Folk', 'Pop', 'Indie'] }

  has_many :band_members
  has_many :bands, through: :band_members
  has_many :song_files

  # PG search
  include PgSearch::Model
  pg_search_scope :global_search,
    against: [ :first_name, :last_name, :genre, :location ],
    using: {
      tsearch: { prefix: true }
    }
end
