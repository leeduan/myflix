class Admin::VideosController < AdminsController
  def new
    @categories = Category.all
    @video = Video.new
  end

  def create
    @video = Video.create(video_params)
    if @video.valid?
      flash[:info] = 'Success! You have added a new video.'
      redirect_to new_admin_video_path
    else
      @categories = Category.all
      flash[:danger] = 'Error, invalid input.'
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :category_id, :small_cover, :large_cover)
  end
end