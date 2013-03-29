require './restaurant_db.rb'

class Restaurant
  
  def self.find(id)    
    restaurant_data = RestaurantsDatabase.execute(<<-SQL, id)
      SELECT *
      FROM restaurants
      WHERE id = ?
    SQL
    
    Restaurant.new(restaurant_data[0])
  end
  
  attr_accessor :id, :name, :neighborhood, :cuisine
  
  def initialize(data)
    @id, @name, @neighborhood, @cuisine = data.values_at("id", "name", "neighborhood", "cuisine")
  end
  
  def self.by_neighborhood(neighborhood)
    RestaurantsDatabase.execute(<<-SQL, neighborhood)
      SELECT *
      FROM restaurants
      WHERE neighborhood = ?
    SQL
  end
  
  def reviews
    RestaurantsDatabase.execute(<<-SQL, id)
      SELECT *
      FROM reviews
      WHERE restaurant_id = ?
    SQL
  end
  
  def average_review_score
    RestaurantsDatabase.execute(<<-SQL, id)
      SELECT AVG(score)
      FROM reviews
      WHERE restaurant_id = ?
    SQL
  end
  
end