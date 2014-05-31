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
  query = "SELECT recipes.id, recipes.name AS recipe_name
  FROM recipes
  WHERE recipes.instructions IS NOT NULL
  ORDER BY recipes.name;"
  @recipes = db_connection do |conn|
    conn.exec_params(query)
  end
  erb :'index'
end

get '/recipes/:id' do
  recipe_id = params[:id]
  query = "SELECT recipes.id, recipes.name AS recipe_name, recipes.instructions, recipes.description, ingredients.name
  FROM recipes
  JOIN ingredients
  ON ingredients.recipe_id = recipes.id
  WHERE recipe_id = $1;"
  @recipe_details = db_connection do |conn|
    conn.exec_params(query, [recipe_id])
  end
  erb :'/show'
end
