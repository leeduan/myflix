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
end