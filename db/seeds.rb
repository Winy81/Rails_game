User.create!(
    email: "adam@adam.com",
    password: "Adamol",
    password_confirmation: "Adamol",
    name: "Test_user_id_1"
)

puts "1 user created"

User.create!(
    email: "adam2@adam.com",
    password: "Adamol",
    password_confirmation: "Adamol",
    name: "Test_user_id_2"
)

puts "Other user created"

User.create!(
    email: "adam3@adam.com",
    password: "Adamol",
    password_confirmation: "Adamol",
    name: "Test_user_id_3"
)

puts "Third user created"

3.times do |character|
  User.find_by(name:"Test_user_id_1").characters.create!(
      name: "#{character}_of_User_with_id_1 "
  )
end

puts "3 Character created for of_User_with_id_1 "

2.times do |character|
  User.find_by(name:"Test_user_id_2").characters.create!(
      name: "#{character}_of_User_with_id_2 "
  )
end

puts "2 Character created for of_User_with_id_2 "

3.times do |character|
  User.find_by(name:"Test_user_id_3").characters.create!(
      name: "#{character}_of_User_with_id_3 "
  )
end

puts "3 Character created for of_User_with_id_3 "