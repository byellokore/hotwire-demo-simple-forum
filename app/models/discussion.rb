class Discussion < ApplicationRecord
  belongs_to :user, default: -> { Current.user }

  after_create_commit -> { broadcast_prepend_to "discussions"}
  after_update_commit -> { broadcast_replace_to "discussions"}
  after_destroy_commit -> { broadcast_remove_to "discussions"}
  validates :name, presence: true

  def to_param
    "#{id}-#{name.downcase}".parameterize
  end
end
