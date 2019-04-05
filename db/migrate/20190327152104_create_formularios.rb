class CreateFormularios < ActiveRecord::Migration[5.2]
  def change
    create_table :formularios do |t|
      t.string :cover_letter
      t.string :title

      t.timestamps
    end
  end
end
