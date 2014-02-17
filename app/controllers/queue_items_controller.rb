class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    unless QueueItem.already_exists?(video, current_user)
      QueueItem.create(video: video, user: current_user, list_order: current_user.queue_count + 1)
    end
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      current_user.normalize_queue_item_list_order
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = 'Invalid list order numbers.'
    end
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    if queue_item.user_has_access?(current_user)
      queue_item.destroy
      current_user.normalize_queue_item_list_order
    end
    redirect_to my_queue_path
  end

  private

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data[:id])
        if queue_item.user_has_access?(current_user)
          queue_item.update_attributes!(list_order: queue_item_data[:list_order])
        end
      end
    end
  end
end