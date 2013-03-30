require './restaurant_db.rb'
#mshopsin nicely done, my solution looks very similar
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
    by_neighb_data = RestaurantsDatabase.execute(<<-SQL, neighborhood)
      SELECT *
        FROM restaurants
       WHERE neighborhood = ?
    SQL
    
    by_neighb_data.map { |restaurant_data| Restaurant.new(restaurant_data) }
  end
  
  def reviews
    RestaurantsDatabase.execute(<<-SQL, id)
      SELECT *
        FROM reviews
       WHERE restaurant_id = ?
    SQL
  end
  
  def average_review_score
    average_score_data = RestaurantsDatabase.execute(<<-SQL, id)
      SELECT AVG(score) avg
        FROM reviews
       WHERE restaurant_id = ?
    SQL
    average_score_data[0]["avg"]
  end
  
  def self.top_restaurants(n)
    top_r_data = RestaurantsDatabase.execute(<<-SQL, n)
          SELECT restaurants.*
            FROM reviews
            JOIN restaurants
              ON reviews.restaurant_id = restaurants.id
        GROUP BY restaurant_id
        ORDER BY AVG(score) DESC
           LIMIT ?
        SQL
    
    top_r_data.map{ |top_r_datum| Restaurant.new(top_r_datum) }    
  end
  
  def self.highly_reviewed_restaurants(min_reviews)
    high_reviewed_data = RestaurantsDatabase.execute(<<-SQL, min_reviews)
            SELECT restaurants.*
              FROM reviews
              JOIN restaurants
                ON reviews.restaurant_id = restaurants.id
          GROUP BY restaurant_id
            HAVING (COUNT(score) >= ?)
          SQL
          
  high_reviewed_data.map { |high_reviewed_datum| Restaurant.new(high_reviewed_datum) }
  end 
  
end









































