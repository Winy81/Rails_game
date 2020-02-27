User.create!(
    email: "adam2@adam.com",
    password: "Adamol",
    password_confirmation: "Adamol",
    name: "Test_user_id_1"
)

puts "1 user created"


10.times do |character|
  User.find_by(name:"Test_user_id_1").characters.create!(
      name: "#{character}_of_User_with_id_1 "
  )
end

puts "10 Character created"