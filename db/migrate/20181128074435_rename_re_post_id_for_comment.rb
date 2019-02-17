class RenameRePostIdForComment < ActiveRecord::Migration[5.1]
  def change
  	rename_column :comments, :re_post_id, :re_comment_id
  	rename_column :comments, :re_account_id, :re_reply_id
  end
end
