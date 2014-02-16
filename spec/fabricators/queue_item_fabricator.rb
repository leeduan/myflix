Fabricator(:queue_item) do
  user
  video
  list_order [1,2,3,4,5].sample
end