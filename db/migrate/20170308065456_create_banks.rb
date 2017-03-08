class CreateBanks < ActiveRecord::Migration[5.0]
  def change
    create_table :banks do |t|
      t.string :title
      t.belongs_to :country, foreign_key: true

      t.timestamps
    end
  end
end
