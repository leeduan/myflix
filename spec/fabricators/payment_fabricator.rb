Fabricator(:payment) do
  user
  amount 9.99
  reference_id { Faker::Number.number(15) }
end