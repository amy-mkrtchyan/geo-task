require 'sinatra/base'
# require 'mongoid'
require 'mongoid/geospatial'

# empty the database
Mongoid.logger = nil
Mongoid::Config.purge!

puts "\nPlease wait while The Universe prepares itself...\n"

manager = Manager.create!(name: 'Manager',
                login: 'manager',
                password: 'manager',
                token: 'v1aW8IkUlvC2edBIVnkc29G-Z_4AngQYu_FpapiSbq0gJpDP1D0NW4P0WReRi26WiVSAclKCare5PZUgsjvzxQ',
                type: User::TYPE[:MANAGER]
)
driver = Driver.create!(name: 'Driver',
               login: 'driver',
               password: 'driver',
               token: 'hkz8fXjcatEUOqeijrozakqNymTwv3FmVGGoi5Zd4vB0a-_Yc_Xpk5n3WLKZPYFClbmNXT49BNzkfLHwC143xw',
               location: [0,0],
               type: User::TYPE[:DRIVER]
)
unassigned = Task.create!(name: 'Task 1',
               pickup: [1,1],
               delivery: [5,5],
               manager: manager
)

assigned = Task.create!(name: 'Task 2',
                        pickup: [0,1],
                        delivery: [7,5],
                        manager: manager,
                        driver: driver
)
