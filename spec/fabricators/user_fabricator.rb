Fabricator(:user) do
  email Faker::Internet.free_email
  password Faker::Internet.password
  full_name Faker::Name.name
end