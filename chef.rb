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
    proteges_data = RestaurantsDatabase.execute(<<-SQL, id)
      SELECT * 
        FROM chefs
       WHERE mentor = ?
     SQL
   
    proteges_data.map { |protege_datum| Chef.new(protege_datum) }
  end
  
  def num_proteges
    num_proteges_data = RestaurantsDatabase.execute(<<-SQL, id)
      SELECT COUNT(*) proteges
        FROM chefs
       WHERE mentor = ?
    SQL
    num_proteges_data[0]["proteges"]
  end
  
  def co_workers   
    co_workers_data = RestaurantsDatabase.execute(<<-SQL, id, id)
      SELECT chefs.*
        FROM cheftenure AS t1 
        JOIN cheftenure AS t2 ON t1.restaurant_id = t2.restaurant_id
        JOIN chefs ON t2.chef_id = chefs.id
       WHERE t1.chef_id = ?
         AND t2.chef_id != ? 
         AND ((t2.start >= t1.start AND t2.start <= t1.end) OR (t1.start >= t2.start AND t1.start <= t2.end))
    SQL
                      
    co_workers_data.map{|co_worker_datum| Chef.new(co_worker_datum)} #mshopsin add space before and after curly braces
  end
  
  def reviews
    RestaurantsDatabase.execute(<<-SQL, id)
      SELECT reviews.*
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
















