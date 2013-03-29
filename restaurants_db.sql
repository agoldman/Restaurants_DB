CREATE TABLE chefs (

  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  mentor INTEGER,
  FOREIGN KEY(mentor) REFERENCES users(id)
);

INSERT INTO chefs (fname, lname)
VALUES ("April", "Goldman");

INSERT INTO chefs (fname, lname, mentor)
VALUES ("Laura", "Palmer", 1), ("Dale", "Cooper", 2), ("Lucy", "Moran", 1);

CREATE TABLE restaurants (

  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  neighborhood VARCHAR(255) NOT NULL,
  cuisine VARCHAR(255) NOT NULL
);

INSERT INTO restaurants (name, neighborhood, cuisine)
VALUES ("Double R", "Twin Peaks", "Diner"), ("Tartine", "Mission", "Bakery"), ("Una Pizza", "SOMA", "Pizza"), ("Zeitgeist", "Mission", "Bar");

CREATE TABLE cheftenure (

  id INTEGER PRIMARY KEY,
  chef_id INTEGER NOT NULL,
  restaurant_id INTEGER NOT NULL,
  head_chef INTEGER NOT NULL,
  start DATE NOT NULL,
  end DATE NOT NULL,
  FOREIGN KEY(chef_id) REFERENCES chefs(id)
  FOREIGN KEY(restaurant_id) REFERENCES restaurants(id)
);

INSERT INTO cheftenure (chef_id, restaurant_id, head_chef, start, end)
VALUES (1, 1, 1, '2000-01-01', '2000-12-31'), (2, 1, 0, '2000-01-01', '2000-12-31'), (2, 2, 1, '2001-01-01', '2001-12-31'), (3, 3, 1, '2011-01-01', '2011-06-31'), (4, 4, 0, '1999-12-01', '1999-12-15');

CREATE TABLE critics (

  id INTEGER PRIMARY KEY,
  screen_name VARCHAR(255) NOT NULL
);

INSERT INTO critics (screen_name)
VALUES ("Donna Hayward"), ("Ben Horne"), ("Leo Johnson"), ("Shelly Johnson");

CREATE TABLE reviews (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  score CHECK (score > -1 AND score < 21),
  published DATE NOT NULL,
  restaurant_id INTEGER NOT NULL,
  critic_id INTEGER NOT NULL,
  FOREIGN KEY(restaurant_id) REFERENCES restaurants(id)
  FOREIGN KEY(critic_id) REFERENCES critics(id)
);

INSERT INTO reviews (body, score, published, restaurant_id, critic_id)
VALUES ("Great Pie!", 20, '2000-12-30', 1, 1), ("Good but long lines", 15, '2001-06-01', 2, 2), ("Good but expensive", 10, '2011-02-01', 3, 3), ("Sassy bouncers", 10, '1999-12-02', 4, 4), ("Bouncers seemed nice to me", 20, '2000-02-15', 4, 3);





