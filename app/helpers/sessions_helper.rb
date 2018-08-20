module SessionsHelper

  # 渡されたユーザーでログイン
  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 現在ログイン中のユーザーを返す（いる場合）
  def current_user
    # ユーザーIDにセッションのユーザーIDを格納した結果、
    # ユーザーIDのセッションが存在すれば
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    # ユーザーIDにクッキーの署名されたユーザーIDを格納した結果、
    # ユーザーIDのクッキーが存在すれば
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      # ユーザーIDが存在し、尚且つクッキーに保存された記憶トークンが署名されたものであれば
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログインしていればtrue, それ以外ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 永続セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウト
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  # 記憶したURL(もしくはデフォルト値)にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

end
