class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_all_ratings

    @sorted_by = params[:sort_by] || session[:sort_by] || {}
    @restricted_by = params[:ratings] || session[:ratings] || {}

    session[:sort_by] = @sorted_by
    session[:ratings] = @restricted_by
    
    logger.debug { session }

    if @restricted_by
      condition_hash = {:conditions => {:rating => @restricted_by.keys} } || {}
    end

    if @sorted_by
      sort_hash = {:order => @sorted_by} || {}
    end

    query_hash = condition_hash.merge(sort_hash)

    @movies = Movie.find(:all, query_hash)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
