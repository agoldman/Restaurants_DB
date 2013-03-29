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
  
  def self.top_restaurants(n)
    RestaurantsDatabase.execute(<<-SQL, n)
          SELECT name, AVG(score)
            FROM reviews
            JOIN restaurants
              ON reviews.restaurant_id = restaurants.id
        GROUP BY restaurant_id
        ORDER BY AVG(score) DESC
           LIMIT ?
        SQL
  end
  
  def self.highly_reviewed_restaurants(min_reviews)
    RestaurantsDatabase.execute(<<-SQL, min_reviews)
            SELECT name
              FROM reviews
              JOIN restaurants
                ON reviews.restaurant_id = restaurants.id
          GROUP BY restaurant_id
            HAVING (COUNT(score) >= ?)
          SQL
  end 
  
end









































