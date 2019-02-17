class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :head
      t.text :body
      t.integer :account_id
      t.integer :as_type
      t.integer :status

      t.timestamps
    end
  end
end
