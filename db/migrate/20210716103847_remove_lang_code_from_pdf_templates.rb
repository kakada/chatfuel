class RemoveLangCodeFromPdfTemplates < ActiveRecord::Migration[6.0]
  def change
    remove_column :pdf_templates, :lang_code, :string
  end
end
