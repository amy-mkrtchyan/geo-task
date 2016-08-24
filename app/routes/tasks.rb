class GeoTask < Sinatra::Base

  get '/tasks' do
    TaskSerializer.new(Task.all).to_json
  end

  post '/tasks', auth: :manager do
    task = @current_user.tasks.create!(task_params)
    TaskSerializer.new(task).to_json
  end

  get '/tasks/:task_id' do |tid|
    task = Task.find(tid)
    TaskSerializer.new(task).to_json
  end

  patch '/tasks/:task_id/take', auth: :driver do |tid|
    task = Task.find(tid)
    task.driver = @current_user
    task.save
    TaskSerializer.new(task).to_json
  end

  delete '/tasks/:task_id', auth: :manager do |tid|
    task = Task.find(tid)
    task.destroy
  end

private

  def task_params
    @request_payload[:task]
  end
end
