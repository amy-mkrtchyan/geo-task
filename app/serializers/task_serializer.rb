class TaskSerializer < Serializer
  OPTIONS = {
      only: %i{name state pickup delivery},
      methods: %i{id manager_name driver_name}
  }
end
