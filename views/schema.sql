
SELECT recipes.id, recipes.name AS recipe_name
  FROM recipes
  WHERE recipes.instructions IS NOT NULL
  ORDER BY recipes.name
  LIMIT 20
  OFFSET (20 * #{@page});


SELECT recipes.id, recipes.name AS recipe_name, recipes.instructions, recipes.description, ingredients.name
  FROM recipes
  JOIN ingredients
  ON ingredients.recipe_id = recipes.id
  WHERE recipe_id = $1;
