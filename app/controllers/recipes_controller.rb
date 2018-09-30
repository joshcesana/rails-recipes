class RecipesController < ApplicationController
  before_action :find_recipe, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @recipes = Recipe.all.order("created_at DESC")
  end

  def show
    @comment = Comment.new
    @comments = @recipe.comments.order("created_at DESC")
  end

  def new
    @recipe = current_user.recipes.build
    @recipe.ingredients.build
    @recipe.directions.build
  end

  def create
    binding.pry
    @recipe = current_user.recipes.build(title: recipe_params[:title])
    binding.pry
    @recipe.description = recipe_params[:description]
    binding.pry

    recipe_params[:ingredients_attributes].each do |key, value|
      binding.pry
      @recipe.ingredients << Ingredient.find_or_initialize_by(name: value[:name])
    end
    binding.pry

    recipe_params[:directions_attributes].each do |key, value|
      binding.pry
      @recipe.directions << Direction.new(step: value[:step])
    end
    binding.pry
    if @recipe.save
      redirect_to @recipe, notice: "Successfully created new recipe"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe
    else
      render 'edit'
    end
  end

  def destroy
    @recipe.destroy
    redirect_to root_path, notice: "Successfully deleted recipe"
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :description, :image, ingredients_attributes: [:id, :name, :_destroy], directions_attributes: [:step, :_destroy])
  end

  def find_recipe
    @recipe = Recipe.find(params[:id])
  end
end
