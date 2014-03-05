class ChangeDescriptionsToText < ActiveRecord::Migration
  def up
    change_column :reviews, :description, :text, :limit => nil
    change_column :videos, :description, :text, :limit => nil
  end

  def down
    change_column :reviews, :description, :string
    change_column :videos, :description, :string
  end
end
