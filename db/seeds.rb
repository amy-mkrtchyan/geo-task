require 'sinatra/base'
# require 'mongoid'
require 'mongoid/geospatial'

# empty the database
Mongoid.logger = nil
Mongoid::Config.purge!

puts "\nPlease wait while The Universe prepares itself...\n"

Manager.create!(name: 'Manager',
                login: 'manager',
                password: 'manager',
                token: 'v1aW8IkUlvC2edBIVnkc29G-Z_4AngQYu_FpapiSbq0gJpDP1D0NW4P0WReRi26WiVSAclKCare5PZUgsjvzxQ',
                type: User::TYPE[:MANAGER]
)
Driver.create!(name: 'Driver',
               login: 'driver',
               password: 'driver',
               token: 'hkz8fXjcatEUOqeijrozakqNymTwv3FmVGGoi5Zd4vB0a-_Yc_Xpk5n3WLKZPYFClbmNXT49BNzkfLHwC143xw',
               type: User::TYPE[:DRIVER]
)
