class CustomFailure < Devise::FailureApp
  def redirect_url
    # ログイン失敗時の遷移先を指定
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
