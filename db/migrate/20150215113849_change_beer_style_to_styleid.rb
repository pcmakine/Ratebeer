class ChangeBeerStyleToStyleid < ActiveRecord::Migration
  def change
    change_table :beers do |t|
      t.rename :style, :style_id
    end
  end
end
