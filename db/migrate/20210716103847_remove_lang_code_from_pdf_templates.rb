class RemoveLangCodeFromPdfTemplates < ActiveRecord::Migration[6.0]
  def change
    change_column :pdf_templates, :name, :string, default: "", null: true
    remove_column :pdf_templates, :lang_code, :string
  end
end
