class GeoTask < Sinatra::Base

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
    user.serialize
  end

  get '/users/:user_id/tasks' do |uid|
    user = User.find_by(login: uid)
    user.serialize
  end

  get '/users/:user_id/tasks/:task_id' do |uid, tid|
    user = User.find_by(login: uid)
    user.tasks.find(ObjectId(tid)).serialize
  end

private

  def user_params
    @request_payload[:user]
  end

end
