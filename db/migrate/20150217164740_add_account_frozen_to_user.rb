class AddAccountFrozenToUser < ActiveRecord::Migration
  def change
    add_column :users, :account_frozen, :boolean
  end
end
