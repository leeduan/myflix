class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items.sort do |item_1, item_2|
      item_1.list_order <=> item_2.list_order
    end
  end

  def create
    video = Video.find(params[:video_id])
    create_queue_video(video)
    redirect_to my_queue_path
  end

  def update; end

  def destroy; end

  private

  def create_queue_video(video)
    QueueItem.create(video: video, user: current_user, list_order: new_queue_item_order)
  end

  def new_queue_item_order
    current_user.queue_items.count + 1
  end
end