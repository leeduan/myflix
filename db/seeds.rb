# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user_1 = User.create(email: 'hello@leeduan.com', password: 'password', full_name: 'Lee Duan')
user_2 = User.create(email: 'joe@leeduan.com', password: 'password', full_name: 'Joe Smith')
user_3 = User.create(email: 'john@leeduan.com', password: 'password', full_name: 'John Doe')
user_4 = User.create(email: 'jolly@leeduan.com', password: 'password', full_name: 'Jolly Babu')

category_1 = Category.create(name: 'TV comedies')
category_2 = Category.create(name: 'TV Dramas')
category_3 = Category.create(name: 'Reality TV')
video_url = 'http://d312nl3mcqlt6j.cloudfront.net/test_video.html'

video_1 = Video.create(
  title: 'Monk',
  description: 'An American adult animated science fiction sitcom created by Matt Groening and developed by Groening and David X. Cohen for the Fox Broadcasting Company.',
  category: category_2,
  url: video_url
)
video_2 = Video.create(
  title: 'Monk',
  description: 'An American adult animated science fiction sitcom created by Matt Groening and developed by Groening and David X. Cohen for the Fox Broadcasting Company.',
  category: category_3,
  url: video_url
)
video_3 = Video.create(
  title: 'South Park',
  description: 'An American adult animated sitcom created by Trey Parker and Matt Stone for the Comedy Central television network.',
  category: category_1,
  url: video_url
)
video_4 = Video.create(
  title: 'Futurama',
  description: 'An American adult animated science fiction sitcom created by Matt Groening and developed by Groening and David X. Cohen for the Fox Broadcasting Company.',
  category: category_2,
  url: video_url
)
video_5 = Video.create(
  title: 'Family Guy',
  description: 'An American adult animated sitcom created by Seth MacFarlane for the Fox Broadcasting Company.',
  category: category_3,
  url: video_url
)
video_6 = Video.create(
  title: 'South Park',
  description: 'An American adult animated sitcom created by Trey Parker and Matt Stone for the Comedy Central television network.',
  category: category_1,
  url: video_url
)
video_7 = Video.create(
  title: 'Futurama',
  description: 'An American adult animated science fiction sitcom created by Matt Groening and developed by Groening and David X. Cohen for the Fox Broadcasting Company.',
  category: category_1,
  url: video_url
)
video_8 = Video.create(
  title: 'Family Guy',
  description: 'An American adult animated sitcom created by Seth MacFarlane for the Fox Broadcasting Company.',
  category: category_2,
  url: video_url
)
video_9 = Video.create(
  title: 'South Park',
  description: 'An American adult animated sitcom created by Trey Parker and Matt Stone for the Comedy Central television network.',
  category: category_3,
  url: video_url
)
video_10 = Video.create(
  title: 'Family Guy',
  description: 'An American adult animated sitcom created by Seth MacFarlane for the Fox Broadcasting Company.',
  category: category_1,
  url: video_url
)
video_11 = Video.create(
  title: 'Monk',
  description: 'An American adult animated science fiction sitcom created by Matt Groening and developed by Groening and David X. Cohen for the Fox Broadcasting Company.',
  category: category_1,
  url: video_url
)
video_12 = Video.create(
  title: 'Family Guy',
  description: 'An American adult animated sitcom created by Seth MacFarlane for the Fox Broadcasting Company.',
  category: category_1,
  url: video_url
)
video_13 = Video.create(
  title: 'Monk',
  description: 'An American adult animated science fiction sitcom created by Matt Groening and developed by Groening and David X. Cohen for the Fox Broadcasting Company.',
  category: category_1,
  url: video_url
)

Review.create(
  rating: 5,
  description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
  video: video_1,
  user: user_1
)

Review.create(
  rating: 1,
  description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
  video: video_2,
  user: user_1
)

Review.create(
  rating: 4,
  description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
  video: video_3,
  user: user_2
)

QueueItem.create(user: user_1, video: video_1, list_order: 1)
QueueItem.create(user: user_1, video: video_2, list_order: 2)
QueueItem.create(user: user_1, video: video_3, list_order: 3)
QueueItem.create(user: user_2, video: video_4, list_order: 1)
QueueItem.create(user: user_2, video: video_5, list_order: 2)

Relationship.create(leader: user_2, follower: user_1)
Relationship.create(leader: user_1, follower: user_2)
Relationship.create(leader: user_3, follower: user_2)
Relationship.create(leader: user_4, follower: user_3)
Relationship.create(leader: user_1, follower: user_4)