module ApplicationHelper
  #ユーザーの経験値が次のレベルまでの必要な経験値に対して何％の進捗があるかを計算する
  def experience_percentage(current_user)
    level = current_user.level
    threshold = LevelSetting.find_by(level: level + 1).threshold
    percentage = (current_user.experience_point.to_f / threshold.to_f) * 100
    percentage > 100 ? "100%" : "#{percentage.round}%"
  end
  
  #ユーザーが次のレベルになるまでに必要な経験値を計算
  def points_to_next_level(current_user)
    level = current_user.level
    current_experience = current_user.experience_point
    next_level_threshold = LevelSetting.find_by(level: level + 1)&.threshold
    return 0 if next_level_threshold.nil?
  
    remaining_points = next_level_threshold - current_experience
    remaining_points.positive? ? remaining_points : 0
  end
  
  #user.statusによってユーザー詳細画面の表示を分岐する
  def can_view_profile?(current_user, user)
    if user == current_user
      true
    elsif user.status == "open"
      true
    elsif user.status == "closed" && current_user.following?(user)
      true
    else
      false
    end
  end
  
  def unchecked_notifications
    @unchecked_notifications = current_user.passive_notifications.where(checked: false)
  end
  
end