namespace :elasticsearch do
  desc "re-index elasticsearch"
  task :reindex => :environment do

    klasses = [User, Feed, Chronicle, Circle, HashTag]

    klasses.each do |klass|
      puts "::::::: #{klass} :::::::::\n"

      ENV['CLASS'] = klass.name
      ENV['INDEX'] = new_index = klass.tire.index.name << '_' << Time.now.strftime('%Y%m%d%H%M%S')
      puts "New index #{new_index}"

      Rake::Task["tire:import"].execute("CLASS='#{klass}'")

      puts '[IMPORT] about to swap index'
      if a = Tire::Alias.find(klass.tire.index.name)
        puts "[IMPORT] aliases found: #{Tire::Alias.find(klass.tire.index.name).indices.to_ary.join(',')}. deleting."
        old_indices = Tire::Alias.find(klass.tire.index.name).indices
        old_indices.each do |index|
          a.indices.delete index
        end
        a.indices.add new_index
        a.save
        old_indices.each do |index|
          puts "[IMPORT] deleting index: #{index}"
          i = Tire::Index.new(index)
          i.delete if i.exists?
        end
      else
        puts "[IMPORT] no aliases found. deleting index. creating new one and setting up alias."
        klass.tire.index.delete
        a = Tire::Alias.new
        a.name(klass.tire.index.name)
        a.index(new_index)
        a.save
        puts "Saved alias #{klass.tire.index.name} pointing to #{new_index}"
      end

      puts "[IMPORT] done. Index: '#{new_index}' created."
    end

  end
  task :create_admin => :environment do
  	AdminUser.create!(:email => 'rakesh.mohan@live.com', :password => 'raview', :password_confirmation => 'raview')
  end

end
