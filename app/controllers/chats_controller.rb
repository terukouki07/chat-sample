class ChatsController < ApplicationController
  def show
    # チャットするユーザーのIDを取得
    @user = User.find(params[:id])
    # ログイン中のユーザーの中間テーブルであるuser_roomsを介して、ログイン中のユーザーのIDと一致するroom_idの値を配列でroomsに代入
    rooms = current_user.user_rooms.pluck(:room_id)
    # チャットするユーザーとログイン中のユーザーですでにroomが存在するかチェック。あれば取得。なければ空。
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    # user_roomが空でないならtrue,空ならfalse
    unless user_rooms.nil?
      @room = user_rooms.room
    else
      # use_roomが空の場合(チャットしたことなかった人の場合)、新しくroomを作成する
      @room = Room.new
      @room.save
      # 中間テーブルにログイン中のユーザーのIDとroomのIDを作成、保存
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      # 中間テーブルにチャットするユーザーのIDとroomのIDを作成、保存
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end
    # room内でのチャットを取得して、インスタンス変数に代入
    @chats = @room.chats
    # 新しくチャットできるようにチャットの新規作成。引数にroom_idには部屋のIDを
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    @chat = current_user.chats.new(chat_params)
    @chat.save
    redirect_to request.referer
  end

  private
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end
end
