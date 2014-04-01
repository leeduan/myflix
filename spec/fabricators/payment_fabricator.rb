Fabricator(:payment) do
  user
  amount 999
  reference_id { Faker::Number.number(15) }
end