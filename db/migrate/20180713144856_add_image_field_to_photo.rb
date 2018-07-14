class AddImageFieldToPhoto < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :avatar, :string
  end
end
