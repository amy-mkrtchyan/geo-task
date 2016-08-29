class GeoTask < Sinatra::Base

  before %r{/tasks/((?!nearby)\w+)} do
    @task = Task.find(params[:captures].first) rescue http_error(404, 'Task not found!')
  end

  get '/tasks' do
    TaskSerializer.new(Task.all).to_json
  end

  get '/tasks/nearby', auth: :driver do
    Task.create_indexes
    nearby_tasks = Task.unassigned.nearby(@current_user.location)
    TaskSerializer.new(nearby_tasks).to_json
  end

  post '/tasks', auth: :manager do
    task = @current_user.tasks.create!(task_params)
    TaskSerializer.new(task).to_json
  end

  get '/tasks/:task_id' do
    TaskSerializer.new(@task).to_json
  end

  patch '/tasks/:task_id/pick', auth: :driver do
    http_error(403, 'Oops! Task is already picked!') if @task.has_driver?
    @task.assign_to(@current_user)
    http_response(200, 'Task was picked!')
  end

  delete '/tasks/:task_id', auth: :manager do
    http_error(403, 'Task is already picked!') if @task.has_driver?
    http_response(200, 'Task was deleted!') if @task.destroy!
  end

private

  def task_params
    http_error(400, 'Invalid JSON') if @request_payload.try(:[],:task).nil?
    @request_payload[:task]
  end
end
