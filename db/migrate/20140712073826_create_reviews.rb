class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :action_id
      t.integer :stars
      t.string :comments

      t.timestamps
    end
  end
end
