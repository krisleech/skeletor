class CreateMetaDefinition < ActiveRecord::Migration
  def self.up
    create_table :meta_definitions do |t|
      t.string   :label_path
      t.string   :label
      t.integer  :parent_id
      t.string   :sort_by
      t.integer  :per_page
      t.string   :default_type # STI class
      t.string   :default_state
      t.text     :autherisation
      t.text     :field_map
      t.text     :flash_messages
      t.boolean  :randomise_permalink, :default => false
      t.boolean  :body_strip_html, :default => false
      t.integer  :body_length
      t.boolean  :record_hits, :default => false
      t.integer  :position, :default => 0
      t.boolean  :notify_admins, :default => 0
    end

    add_index :meta_definitions, :parent_id
    add_index :meta_definitions, :label_path
    add_index :meta_definitions, :label  
  end

  def self.down
    drop_table :meta_definitions    
  end
end
