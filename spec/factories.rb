Factory.define :user do |user|
  user.first_name             "John"
  user.last_name              "Nickerson"
  user.email                  "jsnickerson@gmail.com"
  user.password               "foobar"
  user.password_confirmation  "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@twopickles.com"
end

Factory.define :post do |post|
  post.title        "Post title"
  post.description  "Post description"
  post.trade_for    "Post trade for"
  post.city_id      1
  post.active       true
  post.association  :user
end

Factory.define :trade do |trade|
  trade.content       "Trade content"
  trade.association   :user, :factory => :user
  trade.association   :post, :factory => :post
end

Factory.define :trade_message do |trade_message|
  trade_message.message       "Trade message content"
  trade_message.from_trader   true
  trade_message.association   :trade, :factory => :trade
end

Factory.define :community do |community|
  community.name          "Test Community"
  community.description   "Test Community Description"
end

Factory.define :category do |category|
  category.name          "Test Category"
  category.description   "Test Category Description"
  category.category_type "Goods"
end

Factory.define :state do |state|
  state.name          "Georgia"
  state.abbreviation  "GA"
end
