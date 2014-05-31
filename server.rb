require 'pg'
require 'sinatra'

def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')
    yield(connection)
  ensure
    connection.close
  end
end

get '/recipes' do
  query = "SELECT recipes.id, recipes.name AS recipe_name, recipes.instructions, recipes.description, ingredients.name
  FROM recipes
  JOIN ingredients
  ON ingredients.recipe_id = recipes.id
  ORDER BY recipes.name
  LIMIT 10;"
  @recipes = db_connection do |conn|
    conn.exec_params(query)
  end
  erb :'index'
end








# get '/actors/:id' do
#   id = params[:id]
#   query = "SELECT movies.title, movies.id AS movie_id, cast_members.character, actors.name, actors.id
#     FROM movies
#     JOIN cast_members
#     ON cast_members.movie_id = movies.id
#     JOIN actors
#     ON cast_members.actor_id = actors.id
#     WHERE actors.id = $1
#     ORDER BY movies.title;"
#   @actor_movies = db_connection do |conn|
#     conn.exec_params(query, [id])
#   end
#   erb :'actors/show'
# end
