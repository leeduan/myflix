require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.create(title: 'The Simpsons', description: 'A description')
    expect(Video.first).to eq(video)
  end

  it "belongs to category" do
    dramas = Category.create(name: 'dramas')
    monk = Video.create(title: 'Monk', description: 'A great drama!', category: dramas)
    expect(monk.category).to eq(dramas)
  end

  it "does not save a video without a title" do
    video = Video.create(description: "a great video!")
    expect(Video.count).to eq(0)
  end
  it "does not save a video without a description" do
    video = Video.create(title: "Futurama")
    expect(Video.count).to eq(0)
  end
end