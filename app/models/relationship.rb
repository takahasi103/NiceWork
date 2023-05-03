class Relationship < ApplicationRecord
  #belong_s_to :カラム名の場合、class_nameでクラス名(モデル名)指定する事
  #1人のユーザーはたくさんのユーザーをフォロー(follower)できる
  belongs_to :follower, class_name: "User"
  #1人のユーザーはたくさんのユーザーからフォロー(followed)される
  belongs_to :followed, class_name: "User"
end
