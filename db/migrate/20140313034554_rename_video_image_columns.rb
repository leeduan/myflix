class RenameVideoImageColumns < ActiveRecord::Migration
  def change
    rename_column :videos, :large_cover, :large_cover
    rename_column :videos, :small_cover, :small_cover
  end
end
