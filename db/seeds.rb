# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
State.delete_all
states = State.create!([
{ :name => "Georgia", :abbreviation => "GA" },
])

state = State.find_by_name("Georgia")
state.cities.create({ :name => "Atlanta" })
state.cities.create({ :name => "Savannah" })
state.cities.create({ :name => "Athens" })

Category.delete_all
categories = Category.create!([
  { :name => "Antiques", :description => "Antiques", 
    :category_type => "Goods" },
    
  { :name => "Appliances", :description => "Appliances", 
    :category_type => "Goods" },
    
  { :name => "Baby Products", :description => "Baby Products", 
    :category_type => "Goods" },
    
  { :name => "Books / Movies / Games", 
    :description => "Books / Movies / Games", :category_type => "Goods" },
    
  { :name => "Cars / Boats / Vehicles / Parts", 
    :description => "Cars / Boats / Vehicles / Parts", 
    :category_type => "Goods" },
    
  { :name => "Clothing / Accessories", 
    :description => "Clothing / Accessories", :category_type => "Goods" },
    
  { :name => "Collectibles / Memorabilia", 
    :description => "Collectibles / Memorabilia", :category_type => "Goods" },
    
  { :name => "College Stuff", :description => "College Stuff", 
    :category_type => "Goods" },
    
  { :name => "Electronics", :description => "Electronics", 
    :category_type => "Goods" },
    
  { :name => "Furniture", :description => "Furniture", 
    :category_type => "Goods" },
    
  { :name => "Gift Certificates", 
    :description => "Gift Certificates", :category_type => "Goods" },
    
  { :name => "Health / Beauty", 
    :description => "Health / Beauty", :category_type => "Goods" },
    
  { :name => "Jewelry", :description => "Jewelry", 
    :category_type => "Goods" },
    
  { :name => "Miscellaneous", :description => "Miscellaneous", 
    :category_type => "Goods" },
    
  { :name => "Music", :description => "Music", :category_type => "Goods" },
  
  { :name => "Pet Supplies", 
    :description => "Pet Supplies", 
    :category_type => "Goods" },
    
  { :name => "Sporting Goods", 
    :description => "Sporting Goods", :category_type => "Goods" },
    
  { :name => "Textbooks / School Supplies", 
    :description => "Textbooks / School Supplies", 
    :category_type => "Goods" },
    
  { :name => "Tickets", :description => "Tickets", 
    :category_type => "Goods" },
    
  { :name => "Toys / Hobbies", 
    :description => "Toys / Hobbies", :category_type => "Goods" },
    
  { :name => "Travel", :description => "Travel", 
    :category_type => "Goods" },
    
  { :name => "Beauty", :description => "Beauty", 
    :category_type => "Services" },

  { :name => "Computer", :description => "Computer", 
    :category_type => "Services" },

  { :name => "Creative", :description => "Creative", 
    :category_type => "Services" },
    
  { :name => "Event", :description => "Event", 
    :category_type => "Services" },    

  { :name => "Farm / Garden", :description => "Farm / Garden", 
    :category_type => "Services" },

  { :name => "Financial", :description => "Financial", 
    :category_type => "Services" },
  
  { :name => "Household", :description => "Household", 
    :category_type => "Services" },

  { :name => "Labor", :description => "Labor", 
    :category_type => "Services" },

  { :name => "Legal", :description => "Legal", 
    :category_type => "Services" },

  { :name => "Real Estate", :description => "Real Estate", 
    :category_type => "Services" },

  { :name => "Small Business", :description => "Small Business", 
    :category_type => "Services" },

  { :name => "Tutoring", :description => "Tutoring", 
    :category_type => "Services" },

  { :name => "Writing / Editing", :description => "Writing / Editing", 
    :category_type => "Services" }
])