# class MoviesController < ApplicationController

#   def show
#     id = params[:id] # retrieve movie ID from URI route
#     @movie = Movie.find(id) # look up movie by unique ID
#     # will render app/views/movies/show.<extension> by default
#   end

#   def index
#     @movies = Movie.all
#   end

#   def new
#     # default: render 'new' template
#   end

#   def create
#     @movie = Movie.create!(movie_params)
#     flash[:notice] = "#{@movie.title} was successfully created."
#     redirect_to movies_path
#   end

#   def edit
#     @movie = Movie.find params[:id]
#   end

#   def update
#     @movie = Movie.find params[:id]
#     @movie.update_attributes!(movie_params)
#     flash[:notice] = "#{@movie.title} was successfully updated."
#     redirect_to movie_path(@movie)
#   end

#   def destroy
#     @movie = Movie.find(params[:id])
#     @movie.destroy
#     flash[:notice] = "Movie '#{@movie.title}' deleted."
#     redirect_to movies_path
#   end

#   private
#   # Making "internal" methods private is not required, but is a common practice.
#   # This helps make clear which methods respond to requests, and which ones do not.
#   def movie_params
#     params.require(:movie).permit(:title, :rating, :description, :release_date)
#   end
# end

class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings

    # Retrieve and update session settings for ratings and sort_by
    session[:ratings_to_show] = params[:ratings] || session[:ratings_to_show] || {}
    session[:sort_by] = params[:sort_by] || session[:sort_by]

    # Apply filters based on session settings
    if session[:ratings_to_show].any?
      selected_ratings = session[:ratings_to_show].keys
      @movies = @movies.where(rating: selected_ratings)
    end

    # Apply sorting based on session settings
    sort_column = session[:sort_by]
    if sort_column.present?
      @movies = @movies.order(sort_column)
    end

    # Highlight the selected sorting column header
    @hilite_column = sort_column
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
