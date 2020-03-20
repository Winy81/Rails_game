User.create!(
    email: "adam@adam.com",
    password: "password",
    password_confirmation: "password",
    name: "Test_user_id_1"
)

puts "First user created"

User.create!(
    email: "adam2@adam.com",
    password: "password",
    password_confirmation: "password",
    name: "Test_user_id_2"
)

puts "Other user created"

User.create!(
    email: "adam3@adam.com",
    password: "password",
    password_confirmation: "password",
    name: "Test_user_id_3"
)

puts "Third user created"

2.times do |character|
  User.find_by(name:"Test_user_id_1").characters.create!(
      name: "#{character}_of_User_with_id_1 ",
      status: 'dead'
  )
end

1.times do |character|
  User.find_by(name:"Test_user_id_1").characters.create!(
      name: "#{character}_of_User_with_id_1 ",
      fed_state: rand(30..60),
      happiness: rand(30..60),
      activity_require_level:rand(30..60)
  )
end

puts "3 Character created for of_User_with_id_1 "

2.times do |character|
  User.find_by(name:"Test_user_id_2").characters.create!(
      name: "#{character}_of_User_with_id_2 ",
      status: 'dead'
  )
end

1.times do |character|
  User.find_by(name:"Test_user_id_2").characters.create!(
      name: "#{character}_of_User_with_id_2 ",
      fed_state: rand(30..60),
      happiness: rand(30..60),
      activity_require_level:rand(30..60)
  )
end

puts "3 Character created for of_User_with_id_2 "

5.times do |character|
  User.find_by(name:"Test_user_id_3").characters.create!(
      name: "#{character}_of_User_with_id_3 ",
      status: 'dead'
  )
end

1.times do |character|
  User.find_by(name:"Test_user_id_3").characters.create!(
      name: "#{character}_of_User_with_id_3 ",
      fed_state: rand(30..60),
      happiness: rand(30..60),
      activity_require_level:rand(30..60)
  )
end

puts "6 Character created for of_User_with_id_3 "