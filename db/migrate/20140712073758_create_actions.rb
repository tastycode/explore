class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :action_type
      t.integer :user_id
      t.string :title

      t.timestamps
    end
  end
end
