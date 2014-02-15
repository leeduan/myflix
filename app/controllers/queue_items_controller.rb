class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items.sort do |item_1, item_2|
      item_1.list_order <=> item_2.list_order
    end
  end

  def create
    video = Video.find(params[:video_id])
    create_queue_item(video)
    redirect_to my_queue_path
  end

  def update; end

  def destroy
    queue_item = QueueItem.find(params[:id])
    if user_owns_queue_item?(queue_item)
      queue_item.destroy
      update_order_list
    end
    redirect_to my_queue_path
  end

  private

  def create_queue_item(video)
    QueueItem.create(video: video, user: current_user, list_order: new_queue_item_order)
  end

  def user_owns_queue_item?(queue_item)
    current_user.id == queue_item.user_id
  end

  def new_queue_item_order
    current_user.queue_items.count + 1
  end

  def update_order_list
    queue_items = current_user.queue_items.sort { |x,y| x.list_order <=> y.list_order }
    queue_items.each_with_index do |queue_item, i|
      i += 1
      unless queue_item.list_order == i
        queue_item.list_order = i
        queue_item.save
      end
    end
  end
end