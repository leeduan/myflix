Fabricator(:video) do
  title { Faker::Lorem.sentence }
  description { Faker::Lorem.sentences.join(' ') }
  category
  url { Faker::Internet.url }
end