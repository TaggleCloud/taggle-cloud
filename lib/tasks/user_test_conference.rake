namespace :db do
  desc "Add conference for user testing with name = User testing"
  task :populate => :environment do
    @conf = Conference.find_or_create_by_name_and_location("User testing", "Here")
  end
end