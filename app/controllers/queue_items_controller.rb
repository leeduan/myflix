class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items.sort do |item_1, item_2|
      item_1.list_order <=> item_2.list_order
    end
  end

  def update; end

  def destroy; end
end