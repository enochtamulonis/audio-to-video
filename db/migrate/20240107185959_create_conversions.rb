class CreateConversions < ActiveRecord::Migration[7.1]
  def change
    create_table :conversions do |t|

      t.timestamps
    end
  end
end
