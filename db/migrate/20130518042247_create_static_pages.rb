class CreateStaticPages < ActiveRecord::Migration
  def change
    create_table :static_pages do |t|
      t.string :from
      t.string :subject
      t.text :body

      t.timestamps
    end
  end
end
