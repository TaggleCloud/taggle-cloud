namespace :db do
  desc "Add conference for user testing with name = User testing"
  task :populate => :environment do
    Conference.create(:id => 7357, :name => "User testing", :location => "Here")
  end
end