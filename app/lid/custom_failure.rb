class CustomFailure < Devise::FailureApp
  
  # ログイン失敗時の遷移先を指定
  def redirect_url
    root_path
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
