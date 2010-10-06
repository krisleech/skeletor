

namespace :qwerty do
  namespace :cms do

    task :reset_document_positions => [:environment] do
      counter = 1
      current_meta = nil
      Document.process do | doc, meta |
        if meta != current_meta
          counter = 1
          current_meta = meta
        end
        puts "#{doc.id} / #{meta.id} => #{counter}"
        doc.position = counter
        counter += 1
      end
    end
    
    task :add_view_path_code => [:environment] do
      @total = 0
      [File.join(RAILS_ROOT)].each do |root_path|

        puts root_path

        Dir[root_path + '/**/*.html.erb'].each do |path|

          File.open(path, "r") do |file|
            @process = true
            while (line = file.gets)
              if line.include? 'content_for :debug_info'
                @process = false
                break
              end
            end
          end

          if @process
            @total = @total + 1
            puts "Adding to #{path}"
            File.open(path, 'a') do | file |
              file.puts "<% content_for :debug_info do %>"
              file.puts "VIEW:<%= __FILE__ %><br>"
              file.puts "<% end %>"
            end
          else
            puts "Not adding to #{path}"
          end
        end
      end
      puts '---'
      puts "TOTAL: #{@total}"
    end

    desc "Create some Lipsum entries for a section"
    task :seed => [:environment] do
      
      unless ENV['ids']
        puts 'Supply ids of sections to seed, ids=4,5,12 OR ids=all' 
        Document.roots.each do | d |
          puts d.title + ': ' + d.id.to_s
        end
        exit
      end
      

      if ENV['ids'] == 'all'
        sections = Document.roots.map { |d| d.id }
      else
        sections = ENV['ids'].split(',')
      end
      
      require 'faker'
      
      sections.each do | section_id |
        
        section = Document.find(section_id)
      
        next if section.meta_definition.children.empty?
      
        label = ENV['label'] || section.meta_definition.children.first.label      
        num = (ENV['num'] || 15).to_i
      
        section.children.by_label(label).each { |d| d.destroy }
      
        puts 'Adding to ' + num.to_s + ' ' + label.pluralize + ' to ' + section.title
      
        num.times do | ctr |
          puts ctr.to_s
          doc = Document.create!(
            :title => label.titleize + ' #' + (ctr+1).to_s,
            :author_id => User.first.id,
            :state => 'published',
            :published_at => Time.now - ctr.days,
            :body => Faker::Lorem.paragraphs.join,
            :parent_id => section.id,
            :label => label
          )
        end
      end
    end

    desc "Update meta_definitions from sitemap.yml"
    task :update_meta_definitions => [:environment] do
      puts 'Updating Meta Definitions'
      sitemap = YAML::load(ERB.new(IO.read(File.join(RAILS_ROOT, 'config', 'sitemap.yml'))).result)
      create_meta_definitions(sitemap)
      if @errors_occured
        puts '*' * 20
        puts 'ERRORS OCCURED'
        puts '*' * 20
      end
    end

    def create_meta_definitions(metas, parent_id = nil)
      metas.each do | k, v |
        if MetaDefinition.exists?(:parent_id => parent_id, :label => k)

          m = MetaDefinition.find(:first, :conditions => {:parent_id => parent_id, :label => k})
          m.update_attributes(
            :label => (v['label'] || k),
            :parent_id => parent_id,
            :per_page => v['per_page'],
            :sort_by => v['sort_by'],
            #            :label_path => v['label_path'],
            :default_type => v['default_type'] || 'Document',
            :default_state => v['default_state'],
            :randomise_permalink => v['randomise_permalink'] || false,
            :body_length => v['body_length'],
            :body_strip_html => v['body_strip_html'] || false,
            :field_map => (YAML.dump(v['field_map']) unless v['field_map'].nil?),
            :autherisation => (YAML.dump(v['autherisation']) unless v['autherisation'].nil?),
            :flash_messages => (YAML.dump(v['flash_messages']) unless v['flash_messages'].nil?)


          )
          if m.errors.empty?
            puts "[UPDATED] #{m.label_path}"
          else
            puts "[ERROR] #{m.label_path} #{m.id}"
            puts m.errors.full_messages
            @errors_occured = true
          end
          
        else
          m = MetaDefinition.create!(
            :label => (v['label'] || k),
            :parent_id => parent_id,
            :label_path => v['label_path'],
            :per_page => v['per_page'],
            :sort_by => v['sort_by'],
            :default_type => v['default_type'] || 'Document',
            :default_state => v['default_state'],
            :randomise_permalink => v['randomise_permalink'] || false,
            :body_length => v['body_length'],
            :body_strip_html => v['body_strip_html'] || false,
            :field_map => (YAML.dump(v['field_map']) unless v['field_map'].nil?),
            :autherisation => (YAML.dump(v['autherisation']) unless v['autherisation'].nil?),
            :flash_messages => (YAML.dump(v['flash_messages']) unless v['flash_messages'].nil?)
          )
          
          if m.root?
            d = Document.new(
              :permalink => m.label,
              :author_id => User.first.id,
              :state => 'published',            
              :published_at => Time.now,
              :title => m.label.titleize,
              :meta_definition_id => m.id,
              :label => m.label) # label set manually for roots
            d.type = m.default_type || 'Document'
            d.save!
          end
          
          puts "[NEW] #{m.label_path}"
        end

        unless v['children'].nil?
          create_meta_definitions(v['children'], m.id)
        end
      end
    end

    desc "Delete meta_definitions not in sitemap.yml"
    task :delete_meta_definitions => [:environment] do
      puts 'Deleting Meta Definitions'
      sitemap = YAML::load(ERB.new(IO.read(File.join(RAILS_ROOT, 'config', 'sitemap.yml'))).result)
      delete_meta_defintions(sitemap, MetaDefinition.roots)
    end

    def delete_meta_defintions(sitemap, metas)
      metas.each do | md |
        if sitemap && sitemap[md.label]
          delete_meta_defintions(sitemap[md.label]['children'], md.children) if md.children
        else
          puts 'Deleting ' + md.label_path
          md.destroy
        end
      end
    end

    desc "Overwrite sitemap.yml from Database"
    task :update_sitemap_from_db => [:environment] do
      meta_definitions = MetaDefinition.find(:all, :order => 'label_path', :conditions => { :parent_id => nil })
      sitemap = make_sitemap(meta_definitions)
      sitemap = sitemap.to_yaml.gsub("!ruby/symbol ", ":").sub("---","").split("\n").map(&:rstrip).join("\n").strip
      File.open(File.join(RAILS_ROOT, 'config', 'sitemap.yml'), 'w') {|f| f.write(sitemap) }
    end

    def make_sitemap(meta_definitions)
      fields = %w(notify_admins record_hits per_page sort_by default_type default_state randomise_permalink body_length body_strip_html field_map autherisation flash_messages)

      sitemap = {}

      meta_definitions.each do | md |
        sitemap[md.label] = {}

        fields.each do | field |
          value = md.send(field)
          value = 'true' if value.is_a? TrueClass
          value = 'false' if value.is_a? FalseClass
          sitemap[md.label][field] = value if value && !(value.respond_to?('empty?') && value.empty?)
        end

        # recursive
        sitemap[md.label]['children'] = make_sitemap(md.children) unless md.children.empty?
      end

      return sitemap
    end

    desc "Generate Site from Meta Definitions"
    task :build_site => [:update_meta_definitions] do
      puts "Building Site"

      if User.all.empty?
        puts "Add some users first: rake qwerty:core:seed"
        exit
      end

      

      MetaDefinition.roots.each do | meta_definition |
        next if meta_definition.label == 'page' # special case
        next if meta_definition.children.empty?
        unless Document.exists?(:path => meta_definition.label_path)

          puts "[NEW] #{meta_definition.label}"
          d=Document.new(
            :permalink => meta_definition.label,
            :author_id => User.first.id,
            :state => 'published',            
            :published_at => Time.now,
            :title => meta_definition.label.titleize,
            :meta_definition_id => meta_definition.id,
            :label => meta_definition.label) # label set manually for roots
          d.type = meta_definition.default_type || 'Document'
          d.save!
        else
          puts "[SKIP] #{meta_definition.label} already exists"
        end
      end

      # NOTE: If you get an 'nil' error here it is because you don't have a root document called 'page'
      %w(home contact sitemap).each do | title |
        unless Document.exists?(:permalink => title)
          d=Document.new(
            :permalink => title,
            :author_id => User.first,
            :title => title.titleize,
            :state => 'published',
            :published_at => Time.now,            
            :meta_definition_id => MetaDefinition.find_by_label_path('page').id,
            :label => 'page')
          d.type = 'Document'
          d.save!
        else
          puts "[SKIP] #{title} already exists"
        end
      end
    end

    task :rebuild_site => [:environment] do
      MetaDefinition.destroy_all # will cause deletion of all documents as well
      Rake::Task['qwerty:cms:build_site'].invoke
    end

    desc 'Create YAML test fixtures from data in an existing database.
Defaults to development database.  Set RAILS_ENV to override.'
    task :extract_fixtures => :environment do
      require 'Ya2YAML'
      sql  = "SELECT * FROM %s"
      skip_tables = ["schema_info"]
      ActiveRecord::Base.establish_connection
      (ActiveRecord::Base.connection.tables - skip_tables).each do |table_name|
        i = "000"
        File.open("#{RAILS_ROOT}/test/fixtures/#{table_name}.yml", 'w') do |file|
          data = ActiveRecord::Base.connection.select_all(sql % table_name)
          file.write data.inject({}) { |hash, record|
            hash["#{table_name}_#{i.succ!}"] = record
            hash
          }.ya2yaml
        end
      end
    end
 
  end
end