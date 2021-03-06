require "sinatra"
require "sinatra/reloader" if development?
require_relative "database"

require "sinatra"
require "sinatra/activerecord"

require "./models.rb"

set :database, "sqlite3:miniblog.sqlite3"

helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['admin', 'admin']
  end
end

get '/' do
	@articles = Article.all
	erb :index
end

get '/article/:id' do
 @article = Article.find(params[:id])
 @commentaires = Comment.where(:articles_id => params[:id])
 erb :article_page
end

# create post
post '/article' do
	@article = Article.create(title: params[:title], content: params[:content], photo: params[:photo], rating: params[:rating])
	redirect '/'
end

# update post
put '/article/:id' do
	@article = Article.find(params[:id])
	@article.update(title: params[:title], content: params[:content], photo: params[:photo], rating: params[:rating])
	@article.save
	redirect '/article/'+params[:id]
end

# delete post
delete '/article/:id' do
	@article = Article.find(params[:id])
	@article.destroy
	redirect '/'
end

# create comment
post '/comment/:id' do
	@comment = Comment.create(content: params[:content], articles_id: params[:id])
	redirect '/article/'+params[:id]
end

get '/protected' do
  protected!
  @articles = Article.all
  erb :index
end
