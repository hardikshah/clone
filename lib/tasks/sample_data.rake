namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    require 'faker'
    
    Rake::Task['db:reset'].invoke
    admin = User.create!(:first_name => "John",
                        :last_name => "Nickerson",
                        :email => "jsnickerson@gmail.com", 
                        :password => "foobar",
                        :password_confirmation => "foobar")
    admin.activate!
    admin.toggle!(:admin)
    99.times do |n|
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      email = "example-#{n+1}@twopickles.com"
      password = "password"
      user = User.create!(:first_name => first_name,
                   :last_name => last_name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
      user.activate!
    end
    state = State.create!(:name => "Georgia", :abbreviation => "GA")
    state.cities.create!(:name => "Atlanta")
    state.cities.create!(:name => "Savannah")
    state = State.create!(:name => "California", :abbreviation => "CA")
    state.cities.create!(:name => "San Francisco")
    state.cities.create!(:name => "Cupertino")
    User.all(:limit => 6).each do |user|
      50.times do
        user.posts.create!( :title => Faker::Lorem.sentence(5),
                            :description => Faker::Lorem.sentence(25),
                            :city_id => state.cities.first.id)
      end
    end
  end
end
