class Comment < ApplicationRecord
  audited

  belongs_to :project, optional: false
  belongs_to :user, optional: false

  before_update :mark_as_edited, if: :will_save_change_to_body?

  def mark_as_edited
    return if edited?

    update!(edited: true)
  end
end
