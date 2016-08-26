class UserSerializer < Serializer
  OPTIONS = {
      only:  %i{name type location}
  }
end
