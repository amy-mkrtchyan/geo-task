class GeoTask < Sinatra::Base

  post '/login' do
    user = User.where(login: user_params[:login]).first
    if user.try(:authenticate, user_params[:password])
      user.generate_token!
      {token: user.token}.to_json
    else
      error(401, 'Unauthorized!')
    end
  end

  post '/signup' do
    user = User.create!(user_params)
    user.serialize
  end

  get '/users/:user_id/tasks' do |uid|
    user = User.where(login: uid).first
    user.serialize
  end

  get '/users/:user_id/tasks/:task_id' do |uid, tid|
    user = User.where(login: uid).first
    user.tasks.find(ObjectId(tid)).serialize
  end

private

  def user_params
    @request_payload[:user]
  end

end
