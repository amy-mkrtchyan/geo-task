class GeoTask < Sinatra::Base

  get '/tasks' do
    TaskSerializer.new(Task.all).to_json
  end


  post '/tasks' do
    task = @current_user.tasks.create(task_params)
    TaskSerializer.new(task).to_json
  end

  get '/tasks/:task_id' do |id|
    task = Task.find(id)
    TaskSerializer.new(task).to_json
  end

  delete '/tasks/:task_id' do |id|
    Task.find(id).destroy
  end

private

  def task_params
    @request_payload[:task]
  end
end
