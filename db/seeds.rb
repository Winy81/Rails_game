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

2.times do |character|
  User.find_by(name:"Test_user_id_1").characters.create!(
               name: "#{character}_of_User_with_id_1_dead",
               status: 'dead',
               age: rand(10..100)
              )
end

1.times do |character|
  User.find_by(name:"Test_user_id_1").characters.create!(
               name: "#{character}_of_User_with_id_1",
               fed_state: rand(30..60),
               happiness: rand(30..60),
               age: rand(10..100),
               activity_require_level:rand(30..60)
              )
end

puts "3 Character created for of_User_with_id_1"

2.times do |character|
  User.find_by(name:"Test_user_id_2").characters.create!(
               name: "#{character}_of_User_with_id_2_dead",
               status: 'dead',
               age: rand(10..100)
              )
end

1.times do |character|
  User.find_by(name:"Test_user_id_2").characters.create!(
               name: "#{character}_of_User_with_id_2",
               fed_state: rand(30..60),
               happiness: rand(30..60),
               age: rand(10..100),
               activity_require_level:rand(30..60)
             )
end

puts "3 Character created for of_User_with_id_2 "

5.times do |character|
  User.find_by(name:"Test_user_id_3").characters.create!(
               name: "#{character}_of_User_with_id_3_dead",
               status: 'dead',
               age: rand(10..100)
               )
end

1.times do |character|
  User.find_by(name:"Test_user_id_3").characters.create!(
               name: "#{character}_of_User_with_id_3 ",
               fed_state: rand(30..60),
               happiness: rand(30..60),
               age: rand(10..100),
               activity_require_level:rand(30..60)
              )
end

puts "6 Character created for of_User_with_id_3"

50.times do |user|
  current_user = User.create(email:"Dummy_#{user}@email.com",
                             password: "password",
                             password_confirmation: "password",
                             name: "Dummy_user_#{user}")
  rand(3..10).times do |character |
    Character.create(name:"#{character}_of_#{current_user.name}",
                     user_id:"#{current_user.id}",
                     fed_state: rand(30..60),
                     happiness: rand(30..60),
                     age: rand(10..100),
                     activity_require_level:rand(30..60)
                    )
  end
end

puts "50 User and random number of characters has been created "