class AddGuestUserIdToConversions < ActiveRecord::Migration[7.1]
  def change
    add_column :conversions, :guest_user_id, :string
  end
end
