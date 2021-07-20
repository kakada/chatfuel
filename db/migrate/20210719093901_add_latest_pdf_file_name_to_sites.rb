class AddLatestPdfFileNameToSites < ActiveRecord::Migration[6.0]
  def change
    add_column :sites, :latest_generated_pdf_name, :string
  end
end
