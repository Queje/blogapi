# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

5.times do |n|
  User.create!(
    email: Faker::Internet.email, 
    encrypted_password: "password",
  )  
end

20.times do |n|
  Article.create!(
    title: Faker::Hacker.adjective, 
    content: Faker::ChuckNorris.fact,
    user_id: rand(1..4) ,
  )  
end


puts "#{tp User.all}"
puts "#{tp Article.all}"