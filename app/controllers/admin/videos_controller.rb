class Admin::VideosController < AdminsController
  def new
    @categories = Category.all
    @video = Video.new
  end
end