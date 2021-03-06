require "sinatra"
require "sinatra/reloader" if development?

configure do
  enable :sessions
end


helpers do
  def randomvideo(set)
    set.sample
  end
  def embedyoutube(videonumber)
    '<body style="margin:0;">' + \
    '<object height="100%" width="100%"><param name="movie" value="http://www.youtube.com/v/' + videonumber + '&autoplay=1" /><embed height="100%" src="http://www.youtube.com/v/' + videonumber + '&autoplay=1" type="application/x-shockwave-flash" width="100%"></embed></object>' + \
    '</body>'
  end
end

##INDEX
##Main Welcome Page
get '/' do
  "<h1>Hi!</h1><h2>If you know the url you can play a random video from set of youtube videos!</h2>" + \
    "<a href='set/new'>New Set</a>"
end

##Must go to this page once to set up session parameters
get '/init' do
  session[:sets] ||= {}
end


##NEW
##Temporary new creation without form
#get '/new/:setname/:content' do |setname, content|
  #session[:sets][setname] = content
#end

##Create a new set (really, just update video list of an old set)
get '/sets/new' do
  %{
    <form name="newyoutubeset" action="create" method="post">
      <fieldset>
      <legend>New Set</legend>
      <label for="setname">Set Name</label>
      <input type="text" name="setname" id="setname" placeholder="postmodernjukebox">
      <br>
      <label for="videoset">Set of videos, one link per line:</label>
      <textarea name="videoset" id="videoset" placeholder="VBmCJEehYtU"></textarea>
      <br>
      </fieldset>
      <br>
      <input type="submit" value="Submit">
    </form>
  }
end


##CREATE
post '/sets/create' do
  setname = params["setname"]
  videoset = params["videoset"]
  session[:sets][setname] = videoset.split("\s")

  ##print to page for debugging
  text = ""
  session[:sets][setname].each do |videoname|
    text << videoname.to_s + " has been added to the set " + setname + "<br>"
  end
  text
end


##INDEX
get '/sets' do
  text = "Sets<br>"
  session[:sets].keys.each do |setname|
    text << setname + "<br>"
  end
  text
end


##SHOW
##Displaying Sets

get '/sets/:setname' do |setname|
  if session[:sets][setname]
    text = "Videos<br>"
    session[:sets][setname].each do |v|
      text << v + "<br>"
    end
    text
  else
    "There is not a set with the name " + setname
  end
end


get '/sets/:setname/play' do |setname|
  session[:sets] ||= {}
  if session[:sets][setname]
    embedyoutube(randomvideo(session[:sets][setname]))
  else
    "There is not a set with the name " + setname
  end
end



##Old Non-Dynamic Code
##Display the Video Sets
get '/beyonce' do
  #@@beyonce.to_s
  embedyoutube(randomvideo(@@beyonce))
end

get '/postmodernjukebox' do
  embedyoutube(randomvideo(@@postmodernjukebox))
end


##just view blank params
get '/params' do
  params.inspect
end

##try using the ?var1=1&var2=lol type

##try using the Sinatra type
get '/params/:idlol' do
  params.inspect
end

#Session for troubleshooting
get '/session' do
  session.inspect
end



