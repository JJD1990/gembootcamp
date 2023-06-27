# User.create!(email: 'admin@admin.com', password: 'password', password_confirmation: 'password')
30.times do
  Course.create!({
    title: Faker::Educator.course_name,
    description: Faker::TvShows::GameOfThrones.quote,
    user_id: 1,
    short_description: Faker::Quote.famous_last_words,
    language: Faker::ProgrammingLanguage.name,
    level: 'Beginner',
    price: Faker::Number.between(from: 1000, to: 20000)
  })
end