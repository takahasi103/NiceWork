module ApplicationHelper
  #現在のユーザーの経験値が次のレベルまでの必要な経験値に対して何％の進捗があるかを計算する
  def experience_percentage(current_user)
    level = current_user.level
    threshold = LevelSetting.find_by(level: level + 1).threshold
    percentage = (current_user.experience_point.to_f / threshold.to_f) * 100
    percentage > 100 ? "100%" : "#{percentage.round}%"
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
  
end