class CreateThumbs < ActiveRecord::Migration[5.1]
  def change
    create_table :thumbs do |t|
      t.integer :account_id
      t.integer :post_id
      t.boolean :is_thumb

      t.timestamps
    end
  end
end
