class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.text :description
      t.string :name

      t.timestamps
    end
  end
end
