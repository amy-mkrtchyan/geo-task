class GeoTask < Sinatra::Base

  before '/users/:user_id/*' do
    @user = User.find_by(login: params[:user_id]) if params[:user_id]
  end

  post '/login' do
    user = User.find_by(login: user_params[:login])
    if user.try(:authenticate, user_params[:password])
      user.generate_token!
      {token: user.token}.to_json
    else
      http_error 401
    end
  end

  post '/signup' do
    user = User.create!(user_params)
    UserSerializer.new(user).to_json
  end

  get '/users/:user_id/tasks' do
    TaskSerializer.new(@user.tasks).to_json
  end

  get '/users/:user_id/tasks/active' do
    TaskSerializer.new(@user.tasks.assigned).to_json
  end

  get '/users/:user_id/tasks/delivered' do
    TaskSerializer.new(@user.tasks.done).to_json
  end

private

  def user_params
    @request_payload[:user]
  end

end
