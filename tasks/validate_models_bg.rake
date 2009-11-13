namespace :admin_data do
  desc "Run model valiations"
  task :validate_models_bg => :environment do
    tid = ENV['tid'] || Time.now.strftime('%Y%m%d%H%M%S')
    #tid = '20091113100927'
    klasses = ENV['klasses']
    klasses.split(',').each do |klasss|
      klass = klasss.camelize.constantize 
      puts "processing #{klass.name}"
      errors = []
      klass.paginated_each do |record|
        unless record.valid?
          a = []
          a << klass.name
          a << record.id
          a << record.errors.full_messages
          errors << a
        end
      end
      if errors.any?
        bad_file = File.join(RAILS_ROOT, 'tmp', 'admin_data', 'validate_model', tid , 'bad.txt')
        errors.each { |error| File.open(bad_file, 'a') {|f| f.puts(error.join(' | ')) } }
      else
        good_file = File.join(RAILS_ROOT, 'tmp', 'admin_data', 'validate_model', tid , 'good.txt')
        s = "#{klass.name} | #{klass.send(:count)} records: all valid"
        File.open(good_file, 'a') {|f| f.puts(s)}
      end
    end

  end
end
