namespace :spec do
  desc 'Run the acceptance specs in spec/acceptance'
  RSpec::Core::RakeTask.new(:steak) do |t|
    t.pattern = 'spec/acceptance/**/*_spec.rb'
  end
  
  task :statsetup do
    if File.exist?('spec/acceptance')
      require 'rails/code_statistics'
      ::STATS_DIRECTORIES << ['Acceptance specs', 'spec/acceptance']
      ::CodeStatistics::TEST_TYPES << 'Acceptance specs'
    end
  end
end

#namespace :db do
  #namespace :test do
    #task :prepare do
      ## do nothing
    #end
  #end
#end
