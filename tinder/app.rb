require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require './models'

enable :sessions 

before '/*' do
  @follow = Match.where(user_id: session[:user])
  @followed = Match.where(choosen_user_id: session[:user])
  @matching = []
    @follow.each do |follow|
      @followed.each do |followed|
        if follow.choosen_user_id == followed.user_id
          if follow.choose == true 
            if followed.choose == true
              @matching.push(follow.choosen_user_id)
            end 
          end 
        end 
      end 
    end
end 

before '/:id/*' do
  if !session[:user]
    redirect '/'
  end 
end 

get '/' do 
  if session[:user]
    if Setting.find_by(user_id: session[:user]) == nil 
      Setting.create(
        user_id: session[:user]
        )
    end 
    
    
    @user_notexist = false
    watching = Watching.find_by(user_id: session[:user])
    user_setting = Setting.find_by(user_id: session[:user])
    
    if watching == nil
      Watching.create(
        user_id: session[:user]
        )
    end 
    user_id_id = User.find(session[:user])
    if watching.watching_id > User.count
      @user_notexist = true 
    elsif watching.watching_id == user_id_id.id
      watching.update(
        watching_id:  watching.watching_id  + 1
        )
    redirect '/'
    else 
      
      if user_setting.gender == nil
      elsif User.find(watching.watching_id).gender == user_setting.gender
      elsif user_setting.game == "both"
      elsif User.find(watching.watching_id).gender != user_setting.gender
        watching.update(
          watching_id: watching.watching_id + 1)
        redirect '/'
      end 
      
      if user_setting.game == nil
      elsif User.find(watching.watching_id).game == user_setting.game
      elsif user_setting.game == "all"
      elsif User.find(watching.watching_id).game != user_setting.game
        watching.update(
          watching_id: watching.watching_id + 1)
        redirect '/'
      end 
      
      
      @user = User.find(watching.watching_id)
    end 
    @follow = Match.where(user_id: session[:user])
    @followed = Match.where(choosen_user_id: session[:user])
    @matching = []
    @follow.each do |follow|
      @followed.each do |followed|
        if follow.choosen_user_id == followed.user_id
          if follow.choose == true 
            if followed.choose == true
              @matching.push(follow.choosen_user_id)
            end 
          end 
        end 
      end 
    end 
  end   
  @match = Match.all
  erb :index 
end 

get '/signin' do 
  erb :sign_in 
end 

get '/signup' do 
  erb :sign_up 
end 

post '/signin' do 
  user = User.find_by(mail: params[:mail])
  if user && user.authenticate(params[:password])
    session[:user] = user.id 
  end 
  redirect '/'
end 

post '/signup' do 
  User.all.each do |user|
    if user.mail == params[:mail]
      redirect '/'
    end 
  end 
  @user = User.create(name: params[:name], 
  mail: params[:mail], password: params[:password], 
  password_confirmation: params[:password_confirmation],
  game: params[:game], rank: params[:rank],
  gender: params[:gender], 
  image_url: params[:image_url], profile: params[:profile], 
  age: params[:age])
  
  Watching.create(
    watching_id: 1, 
    user_id: @user.id)
  if @user.persisted? 
    session[:user] = @user.id
    redirect '/'
  else 
    redirect '/signup'
  end 

end 

get '/profile_edit' do
  @user = User.find(session[:user])
  @user_game = ["all", "Fortnite", "Apex", "Valorant", 
  "PokemonGo", "Rocket League", "League of Legends", 
  "どうぶつの森"]
  @user_gender = ["both", "men", "women", "others"]
  erb :profile_edit
end 

post '/profile_edit' do 
  @user = session[:user]
  @user = User.update(game: params[:game], rank: params[:rank],
  gender: params[:gender], 
  image_url: params[:image_url], profile: params[:profile], 
  age: params[:age])
  
  redirect '/'
end 

get '/profile' do 
  erb :profile
end 

get '/signout' do 
  session[:user] = nil 
  redirect '/'
end 

get '/user_page' do
  erb :user_page
end 

get '/user/:id/delete' do 
  User.find(params[:id]).destroy
  redirect '/user_page'
end 

post '/:id/choose' do 
  Match.create(
    user_id: session[:user], 
    choosen_user_id: params[:id], 
    choose: true 
    )
  watching = Watching.find_by(user_id: session[:user])
  
  watching.update(
    watching_id:   watching.watching_id  + 1
    )
 
  redirect '/'
end

post '/:id/not_choose' do 
  Match.create(
    user_id: session[:user], 
    choosen_user_id: params[:id], 
    choose: false
    )
  
  watching = Watching.find_by(user_id: session[:user])
  
  watching.update(
    watching_id:   watching.watching_id  + 1
    )
  redirect '/'
end

post '/matching/:id/delete' do 
  Match.find_by(choosen_user_id: params[:id]).delete
  redirect '/'
end

get '/matching_page' do 
  @follow = Match.where(user_id: session[:user])
    @followed = Match.where(choosen_user_id: session[:user])
    @matching = []
    @follow.each do |follow|
      @followed.each do |followed|
        if follow.choosen_user_id == followed.user_id
          if follow.choose == true 
            if followed.choose == true
              @matching.push(follow.choosen_user_id)
            end 
          end 
        end 
      end 
    end 
  erb :matching_page
end 

get '/:id/friend_profile' do 
  @friend = User.find(params[:id])
  erb :friend_profile
end 

get '/setting' do
  @setting_gender = ["both", "men", "women", "others"]
  @setting_game = ["all", "Fortnite", "Apex", "Valorant", 
  "PokemonGo", "Rocket League", "League of Legends", 
  "どうぶつの森"]
  erb :setting
end 

post '/setting/' do
  setting_user = Setting.find_by(user_id: session[:user]) 
  setting_user.update(
      gender: params[:gender],
      game: params[:game]
      )
  redirect '/setting'
end 

get '/:id/chat' do
  
  @chat = Chat.where(user_id: session[:user], 
  sent_id: params[:id]).or(Chat.where(user_id: params[:id], 
  sent_id: session[:user]))
  @matched = User.find(params[:id])
  erb :chat
end 

post '/:id/chat' do 
  @matched = User.find(params[:id])
  Chat.create(
    user_id: session[:user],
    sent_id: params[:id], 
    text: params[:text]
    )
  redirect "/#{@matched.id}/chat"
end 

get '/video' do 
  erb :video
end 