class Post < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  belongs_to :user
  
  has_one_attached :image
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  #favoritesテーブルの指定したレコードのis_cancelの値を確認する
  def is_cancelled?(current_user, post)
    favorite = Favorite.find_by(user: user, post: post)
    favorite&.is_cancel || false
  end 
  
  #favoritesテーブルのis_cancelがfalseのいいね数をカウントする
  def count_valid_likes
    self.favorites.where(is_cancel: false).count
  end
  
  #検索方法
  def self.looks(word)
    @post = Post.where("body LIKE?", "%#{word}%")
  end 
  
  #いいね通知
  def create_notification_favorite!(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, 1])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 1
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end
  
  #コメント通知
  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 2
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
  
end
