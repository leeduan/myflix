Fabricator(:review) do
  rating { Random.new.rand(4) + 1 }
  description { Faker::Lorem.sentences.join(' ') }
end