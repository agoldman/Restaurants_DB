require './restaurant_db.rb'

class Critic
  
  def self.find(id)
    critic_data = RestaurantsDatabase.execute(<<-SQL, id)
      SELECT *
      FROM critics
      WHERE id = ?
    SQL
    
    Critic.new(critic_data[0])
  end
  
  attr_reader :id
  attr_accessor :screen_name
  
  def initialize(data)
    @screen_name, @id = data.values_at("screen_name", "id")
  end
  
  def reviews
    RestaurantsDatabase.execute(<<-SQL, id)
      SELECT *
      FROM reviews
      WHERE critic_id = ?
    SQL
  end
  
  def average_review_score
    RestaurantsDatabase.execute(<<-SQL, id)
      SELECT AVG(score)
      FROM reviews
      WHERE critic_id = ?
    SQL
  end
  
  def unreviewed_restaurants
    RestaurantsDatabase.execute(<<-SQL, id)
    
      SELECT name
      FROM restaurants
      WHERE id NOT
      IN (SELECT reviews.restaurant_id
      FROM critics 
      JOIN reviews
      ON critics.id = reviews.critic_id
      WHERE reviews.critic_id = ?)  
    
    SQL
  end

end














