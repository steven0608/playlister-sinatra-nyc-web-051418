require 'rack-flash'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }
  enable :sessions 
  use Rack::Flash

  get '/' do
    erb :index
  end

  get '/songs' do
    @songs=Song.all
    erb :"songs/index"
  end

  get '/artists' do
    @artists=Artist.all
    erb :"artists/index"
  end

  get '/genres' do
    @genres=Genre.all
    erb :"genres/index"
  end

  get "/songs/new" do 
    # binding.pry
    @genres = Genre.all
    erb :"songs/new"
  end

  get "/songs/:slug" do
    name = params[:slug].gsub("-"," ")
    @song = Song.find_by(name: name)
    @artist = @song.artist
    @genres = @song.genres
    # binding.pry
    erb :"songs/show"
  end

  get "/artists/:slug" do
    name = params[:slug].gsub("-"," ")
    # binding.pry
    @artist=Artist.find_by(name: name)
    @songs = @artist.songs
    @genres = @songs.map {|song| song.genres}
    @genres = @genres.flatten
    # binding.pry
    erb :"artists/show"
  end

  get "/genres/:slug" do
    name = params[:slug].gsub("-"," ")
    @genre=Genre.find_by(name: name)
    @songs = @genre.songs
    
    @artists = @songs.map {|song| song.artist}
    @artists = @artists.flatten
    # binding.pry
    erb :"genres/show"
  end



  post '/songs' do
    # binding.pry
    # p params
    song = params[:song_name]
    artist = params[:artist_name]
    # genres = params[:song][:genre_name]
    # @genre=Genre.find_by(id:params[:song][:genre_name])
    @song=Song.create(name:song)
    artist_search = Artist.find_by(name: artist)
    if !artist_search
      @artist=Artist.create(name:artist)
    else
      @artist = artist_search
    end
    
    @song.artist=@artist
    # @song.genres << genres
    @song.save  
    #genre array
    #  @genres = Genre.all
    #  @song = Song.create(params)
    @song.genres << Genre.find_by(id:params[:song][:genre_name])
    # binding.pry
    flash[:message] = "Successfully created song."
    redirect to "/songs/#{@song.slug}"
  end

  get "/songs/:slug/edit" do 
    name=params[:slug].gsub("-"," ")
    @song=Song.find_by(name:name)
    @artist=@song.artist
    @genres=Genre.all
    erb :"songs/edit"
    # binding.pry
  end


  patch "/songs/:slug/edit" do 
    @song=Song.find_by(name:params["slug"])
    @artist = @song.artist
    @artist.update(name: params["artist"])
    # @song.genres Genre.find_by(id:)
@song.genres=[]
    params["song"]["genre_name"].each do |id|
      @song.genres << Genre.find_by(id:id.to_i)
      @song.save
    end
    redirect to "/songs/#{params[:slug]}"
  end

end