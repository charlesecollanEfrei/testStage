class CreateArticles < ActiveRecord::Migration[5.1]
  def change
   create_table :articles do |t|
       t.string :title
       t.text :content
       t.string :photo
       t.string :rating
   end
 end
end