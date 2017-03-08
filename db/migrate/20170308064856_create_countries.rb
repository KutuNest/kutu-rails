class CreateCountries < ActiveRecord::Migration[5.0]
  def change
    create_table :countries do |t|
      t.string :title
      t.string :name
      t.string :tld

      t.timestamps
    end
  end
end
