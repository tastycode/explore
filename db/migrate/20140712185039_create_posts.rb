class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :author_id
      t.integer :recipient_id
      t.string :body
      

      t.timestamps
    end
  end
end
