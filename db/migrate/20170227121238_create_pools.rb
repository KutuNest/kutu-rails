class CreatePools < ActiveRecord::Migration[5.0]
  def change
    create_table :pools do |t|
      t.belongs_to :groupement, foreign_key: true
      t.string :title
      t.integer :amount
      t.integer :position
      t.integer :feeders_count
      t.integer :timeout

      t.timestamps
    end
  end
end
