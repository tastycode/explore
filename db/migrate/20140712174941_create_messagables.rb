class CreateMessagables < ActiveRecord::Migration
  def change
    create_table :messagables do |t|

      t.timestamps
    end
  end
end
