class Home < ActiveRecord::Base
self.table_name = "TEST"
@home=Home.all
end