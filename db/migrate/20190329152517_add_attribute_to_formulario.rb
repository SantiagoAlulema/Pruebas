class AddAttributeToFormulario < ActiveRecord::Migration[5.2]
  def up
    add_column :formularios, :categoria, :string
  end

  def down
    remove_column :formularios, :categoria
  end
end
