class AddStatusUpdatedByToBlogs < ActiveRecord::Migration
  def change
    add_reference :blogs, :status_updated_by, index: true
  end
end
