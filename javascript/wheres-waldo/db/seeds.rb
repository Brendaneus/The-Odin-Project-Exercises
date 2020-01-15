# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

album_one = Album.create!(title: "First Album")

picture_one = album_one.pictures.create!(title: "First Picture")
picture_one.image.attach(io: File.open("public/pictures/sample.png"), filename: "sample.png")

characters = {
  waldo: Character.create!(name: 'Waldo'),
  wenda: Character.create!(name: 'Wenda'),
  odlaw: Character.create!(name: 'Odlaw'),
  wizard: Character.create!(name: 'Wizard Whitebeard'),
  woof: Character.create!(name: 'Woof')
}

characters.each do |key, character|
  character.avatar.attach(io: File.open("public/characters/#{key}.jpg"), filename: "#{key.to_s}.jpg")
end

locations = {
  one: {
    odlaw: picture_one.locations.create!(
      character: characters[:odlaw],
      hint: "He's got a bone to pick...",
      top_coord: 55,
      bottom_coord: 75,
      left_coord: 50,
      right_coord: 60
    )
  }
}

users = {
  admin: User.create!(name: 'Admin', password: 'secret', password_confirmation: 'secret', admin: true),
  one: User.create!(name: 'User One', password: 'password', password_confirmation: 'password')
}

scores = {
  admin: {
    unfinished: users[:admin].scores.create!(picture: picture_one, elapsed_time: 100),
    finished: users[:admin].scores.create!(picture: picture_one, elapsed_time: 100, finished: true)
  },
  one: {
    unfinished: users[:one].scores.create!(picture: picture_one, elapsed_time: 100),
    finished: users[:one].scores.create!(picture: picture_one, elapsed_time: 100, finished: true)
  }
}

scores[:admin][:finished].locations << picture_one.locations
scores[:one][:finished].locations << picture_one.locations
