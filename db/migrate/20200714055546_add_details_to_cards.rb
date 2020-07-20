# frozen_string_literal: true

class AddDetailsToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :num, :integer
    add_column :cards, :suit, :string
    add_column :cards, :trump, :string
  end
end
