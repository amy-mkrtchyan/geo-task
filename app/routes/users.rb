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
    UserSerializer.new(user).to_json
  end

  get '/user/tasks' do
    TaskSerializer.new(@current_user.tasks).to_json
  end

  get '/user/tasks/:task_id' do
    task = @current_user.tasks.find(params[:task_id])
    TaskSerializer.new(task).to_json
  end

  get '/user/tasks/active' do
    TaskSerializer.new(@current_user.tasks.assigned).to_json
  end

  get '/user/tasks/delivered' do
    TaskSerializer.new(@current_user.tasks.done).to_json
  end

  patch '/user/location', auth: :driver do
    @current_user.update!(location: user_params[:location])
    http_response(200, 'Location was updated!')
  end

  patch '/user/tasks/:task_id/unpick', auth: :driver do
    @current_user.tasks.find(params[:task_id]).unpick!
    http_response(200, 'Task was unpicked!')
  end

  patch '/user/tasks/:task_id/deliver', auth: :driver do
    @current_user.tasks.find(params[:task_id]).deliver!
    http_response(200, 'Task was delivered!')
  end


private

  def user_params
    http_error(400, 'Invalid JSON') if @request_payload.try(:[],:user).nil?
    @request_payload[:user]
  end
end
