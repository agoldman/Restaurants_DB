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
  
  def co_workers   
    RestaurantsDatabase.execute(<<-SQL, id, id)
      SELECT t2.chef_id
      FROM cheftenure AS t1 
      JOIN cheftenure AS t2 ON t1.restaurant_id = t2.restaurant_id
      WHERE t1.chef_id = ?
      AND t2.chef_id != ? 
      AND ((t2.start >= t1.start AND t2.start <= t1.end) OR (t1.start >= t2.start AND t1.start <= t2.end))
      GROUP BY t1.chef_id
    SQL
  end
  
  def reviews
    RestaurantsDatabase.execute(<<-SQL, id)
      SELECT body, score, published, reviews.restaurant_id
      FROM cheftenure 
      JOIN reviews 
      ON cheftenure.restaurant_id = reviews.restaurant_id 
      WHERE chef_id = ?
      AND published < end 
      AND published > start
      AND head_chef = 1
    SQL
  end

end
















