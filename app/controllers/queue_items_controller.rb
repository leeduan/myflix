class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    create_queue_item(video) unless exists_in_queue?(video)
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      normalize_queue_item_list_orders
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = 'Invalid list order numbers.'
    end
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    if user_owns_queue_item?(queue_item)
      queue_item.destroy
      normalize_queue_item_list_orders
    end
    redirect_to my_queue_path
  end

  private

  def exists_in_queue?(video)
    QueueItem.find_by user: current_user, video: video
  end

  def create_queue_item(video)
    QueueItem.create(video: video, user: current_user, list_order: new_queue_item_order)
  end

  def new_queue_item_order
    current_user.queue_items.count + 1
  end

  def user_owns_queue_item?(queue_item)
    current_user.id == queue_item.user_id
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data[:id])
        if user_owns_queue_item?(queue_item)
          queue_item.update_attributes!(list_order: queue_item_data[:list_order])
        end
      end
    end
  end

  def normalize_queue_item_list_orders
    current_user.queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(list_order: index + 1)
    end
  end
end