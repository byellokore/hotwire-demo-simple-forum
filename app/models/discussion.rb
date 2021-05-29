class Discussion < ApplicationRecord
  belongs_to :user, default: -> { Current.user }
  belongs_to :category, counter_cache: true, touch: true 

  broadcasts_to :category, inserts_by: :prepend

  after_create_commit -> { broadcast_prepend_to "discussions" }
  after_update_commit -> { broadcast_replace_to "discussions" }
  after_destroy_commit -> { broadcast_remove_to "discussions" }

  validates :name, presence: true
  has_many :posts, dependent: :destroy

  accepts_nested_attributes_for :posts

  scope :pinned_first, -> { order(pinned: :desc) }

  delegate :name, prefix: :category, to: :category, allow_nil: true

  def to_param
    "#{id}-#{name.downcase}".parameterize
  end
end
