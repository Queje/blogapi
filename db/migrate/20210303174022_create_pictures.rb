class CreatePictures < ActiveRecord::Migration[6.1]
  def change
    create_table :pictures do |t|
      t.references :article, null: false, foreign_key: true
      t.boolean :private, default: false

      t.timestamps
    end
  end
end
