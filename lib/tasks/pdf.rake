namespace :pdf do
  desc 'generate a sample PDF file with +name+ and +number+ as args'
  task :sample, %i[name number] => :environment do |_, args|
    Pdf::Certificate.generate(args[:name], args[:number])
  end
end
