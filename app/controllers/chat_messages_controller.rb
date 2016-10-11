class ChatMessagesController < ApplicationController
  def history
    room = params[:room]
    # messages = ChatMessage.where(room: room)

    messages = ChatMessage.where('room.key' => room['key'])
    render json: messages.map(&:client_data)
  end
end