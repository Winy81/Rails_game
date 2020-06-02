User.create!(email: "adam@adam.com",
             password: "password",
             password_confirmation: "password",
             name: "Test_user_id_1"
)

puts "First user created"

User.create!(email: "adam2@adam.com",
             password: "password",
             password_confirmation: "password",
             name: "Test_user_id_2"
)

puts "Other user created"

User.create!(email: "adam3@adam.com",
             password: "password",
             password_confirmation: "password",
             name: "Test_user_id_3"
)

puts "Third user created"

4.times do |character|
  User.find_by(name:"Test_user_id_1").characters.create!(
      name: "#{character}_of_User_with_id_1",
      fed_state: rand(30..60),
      happiness: rand(30..60),
      age: rand(10..300),
      activity_require_level:rand(30..60),
      status:'dead',
      died_on: Time.now
  )
end

1.times do |character|
  User.find_by(name:"Test_user_id_1").characters.create!(
      name: "#{character}_of_User_with_id_1_a",
      fed_state: rand(30..60),
      happiness: rand(30..60),
      age: rand(10..300),
      activity_require_level:rand(30..60),
      status:'alive'
  )
end

puts "5 Character created for of_User_with_id_1 one is surely alive"

6.times do |character|
  User.find_by(name:"Test_user_id_2").characters.create!(
      name: "#{character}_of_User_with_id_2",
      fed_state: rand(30..60),
      happiness: rand(30..60),
      age: rand(10..300),
      activity_require_level:rand(30..60),
      status:'dead',
      died_on: Time.now
  )
end

puts "6 Character created for of_User_with_id_2 "

5.times do |character|
  User.find_by(name:"Test_user_id_3").characters.create!(
      name: "#{character}_of_User_with_id_3",
      fed_state: rand(30..60),
      happiness: rand(30..60),
      age: rand(10..200),
      activity_require_level:rand(30..60),
      status:'dead',
      died_on: Time.now
  )
end

puts "5 Character created for of_User_with_id_3"

puts "Prepare pack of data: "

75.times do |user|
  current_user = User.create(email:"Dummy_#{user}@email.com",
                             password: "password",
                             password_confirmation: "password",
                             name: "Dummy_user_#{user}")
  rand(3..10).times do |character |
    Character.create(name:"#{character}_of_#{current_user.name}",
                     user_id:"#{current_user.id}",
                     fed_state: rand(30..60),
                     happiness: rand(30..60),
                     age: rand(10..200),
                     activity_require_level:rand(30..60),
                     status:'dead',
                     died_on: Time.now
    )
  end
  print '.'
end

puts "75 User and #{Character.all.count} characters has been created for them."

puts "The #{Character.all.count} character shortly optimized"

users = User.all

users.each do |user|
  random_factor = rand(1..5)
  if random_factor > 1
    users_character = Character.where(user_id:user.id).last
    users_character.update_attributes(status:'alive', died_on:nil)
    print '.'
  end
end

puts "All of characters has been updated "


User.all.each do |user|
  Wallet.create(user_id:user.id, amount:100)
  print '.'
end

puts "User's Wallets has been created"