# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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