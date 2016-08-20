class TaskSerializer < Serializer
  OPTIONS = {
      only: %i{name state location},
      methods: %i{id manager_name driver_name}
  }
end
