# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email: 'hello@leeduan.com', password: 'password', full_name: 'Lee Duan')
comedies = Category.create(name: 'TV comedies')
dramas = Category.create(name: 'TV Dramas')
reality = Category.create(name: 'Reality TV')

Video.create(
  title: 'Monk',
  description: 'An American adult animated science fiction sitcom created by Matt Groening and developed by Groening and David X. Cohen for the Fox Broadcasting Company.',
  small_cover_url: 'monk',
  large_cover_url: 'monk_large',
  category: dramas
)
Video.create(
  title: 'Monk',
  description: 'An American adult animated science fiction sitcom created by Matt Groening and developed by Groening and David X. Cohen for the Fox Broadcasting Company.',
  small_cover_url: 'monk',
  large_cover_url: 'monk_large',
  category: reality
)
Video.create(
  title: 'South Park',
  description: 'An American adult animated sitcom created by Trey Parker and Matt Stone for the Comedy Central television network.',
  small_cover_url: 'south_park',
  large_cover_url: 'large_placeholder',
  category: comedies
)
Video.create(
  title: 'Futurama',
  description: 'An American adult animated science fiction sitcom created by Matt Groening and developed by Groening and David X. Cohen for the Fox Broadcasting Company.',
  small_cover_url: 'futurama',
  large_cover_url: 'large_placeholder',
  category: comedies
)
Video.create(
  title: 'Family Guy',
  description: 'An American adult animated sitcom created by Seth MacFarlane for the Fox Broadcasting Company.',
  small_cover_url: 'family_guy',
  large_cover_url: 'large_placeholder',
  category: comedies
)
Video.create(
  title: 'South Park',
  description: 'An American adult animated sitcom created by Trey Parker and Matt Stone for the Comedy Central television network.',
  small_cover_url: 'south_park',
  large_cover_url: 'large_placeholder',
  category: comedies
)
Video.create(
  title: 'Futurama',
  description: 'An American adult animated science fiction sitcom created by Matt Groening and developed by Groening and David X. Cohen for the Fox Broadcasting Company.',
  small_cover_url: 'futurama',
  large_cover_url: 'large_placeholder',
  category: comedies
)
Video.create(
  title: 'Family Guy',
  description: 'An American adult animated sitcom created by Seth MacFarlane for the Fox Broadcasting Company.',
  small_cover_url: 'family_guy',
  large_cover_url: 'large_placeholder',
  category: comedies
)
Video.create(
  title: 'South Park',
  description: 'An American adult animated sitcom created by Trey Parker and Matt Stone for the Comedy Central television network.',
  small_cover_url: 'south_park',
  large_cover_url: 'large_placeholder',
  category: comedies
)

Review.create(
  rating: 5,
  description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
  video: Video.first,
  user: User.first
)

Review.create(
  rating: 1,
  description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
  video: Video.first,
  user: User.first
)

Review.create(
  rating: 4,
  description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
  video: Video.first,
  user: User.first
)