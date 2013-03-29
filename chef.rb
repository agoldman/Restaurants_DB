require './restaurant_db.rb'

class Chef
  
  def self.find(id)
    chef_data = RestaurantsDatabase.execute(<<-SQL, id)
      SELECT *
      FROM chefs
      WHERE id = ?
    SQL
    
    Chef.new(chef_data[0])
  end
  
  attr_accessor :id, :fname, :lname, :mentor
  
  def initialize(data)
    @id, @fname, @lname, @mentor = data.values_at("id", "fname", "lname", "mentor")
  end
  
  def proteges
    RestaurantsDatabase.execute(<<-SQL, id)
      SELECT * 
      FROM chefs
      WHERE mentor = ?
    SQL
  end
  
  def num_proteges
    RestaurantsDatabase.execute(<<-SQL, id)
      SELECT COUNT(*) num_proteges
      FROM chefs
      WHERE mentor = ?
    SQL
  end

end