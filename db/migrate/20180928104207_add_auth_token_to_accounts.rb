class AddAuthTokenToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :auth_token, :string
  end
end
