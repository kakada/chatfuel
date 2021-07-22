class RemoveLangCodeFromPdfTemplates < ActiveRecord::Migration[6.0]
  def up
    change_column :pdf_templates, :name, :string, default: "", null: true
    remove_column :pdf_templates, :lang_code, :string
    remove_column :pdf_templates, :name, :string
  end

  def down
    add_column :pdf_templates, :lang_code, :string
    add_column :pdf_templates, :name, :string
    change_column :pdf_templates, :name, :string, null: false
  end
end
