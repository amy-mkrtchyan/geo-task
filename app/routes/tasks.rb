class GeoTask < Sinatra::Base

  before '/tasks/:task_id/?*' do
    @task = Task.find(params[:task_id]) if is_legal?(params[:task_id])
  end

  get '/tasks/?' do
    TaskSerializer.new(Task.all).to_json
  end

  get '/tasks/nearby' do
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
    @task.assign_to(@current_user)
    TaskSerializer.new(@task).to_json
  end

  patch '/tasks/:task_id/unpick', auth: :driver do
    @task.unpick!
    TaskSerializer.new(@task).to_json
  end

  patch '/tasks/:task_id/deliver', auth: :driver do
    @task.assign_to(@current_user) if @task.driver.nil?
    @task.deliver!
    TaskSerializer.new(@task).to_json
  end

  delete '/tasks/:task_id', auth: :manager do
    @task.destroy
  end

private

  def task_params
    @request_payload[:task]
  end

  def is_legal? (str)
    BSON::ObjectId.legal?(str)
  end
end
