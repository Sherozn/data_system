class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.integer :account_id
      t.integer :post_id
      t.integer :status
      t.text :content
      t.integer :as_type
      t.integer :re_post_id
      t.integer :re_account_id

      t.timestamps
    end
  end
end
