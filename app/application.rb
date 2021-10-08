require "pry"

class Application
  def call(env)
    req = Rack::Request.new(env)

    if req.path.match(/hello/)
      send_hello
      # elsif req.path.match(/decades/) && req.get?
      #   choose_decade(req)
    elsif req.path.match(/songs/) && req.get?
      send_songs(req)
    elsif req.path.match(/user_games/) && req.post?
      create_user_game(req)
    elsif req.path.match(/games/) && req.post?
      create_game(req)
    elsif req.path.match(/users/) && req.patch?
      send_points(req)
    elsif req.path.match(/leaderboard/) && req.get?
      send_leaderboard
    elsif req.path.match(/check_user/) && req.get?
      username_search = req.params["username"]
      searched_user = User.all.find do |user_instance|
        user_instance.username == username_search
      end
      if searched_user
        return [201, { "Content-Type" => "application/json" }, [{ :message => "This user already exists" }.to_json]]
      else
        return [201, { "Content-Type" => "application/json" }, [{ :message => "User does not exist" }.to_json]]
      end
    elsif req.path.match(/users/) && req.get?
      username_search = req.params["username"]
      password_search = req.params["password"]
      searched_user = User.all.find do |user_instance|
        user_instance.username == username_search && user_instance.password == password_search
      end
      if searched_user
        return [201, { "Content-Type" => "application/json" }, [searched_user.to_json]]
      else
        return [201, { "Content-Type" => "application/json" }, [{ :message => "User does not exist" }.to_json]]
      end
    elsif req.path.match(/users/) && req.post?
      create_user(req)
    else
      send_not_found
    end
  end

  ###################  Methods

  def send_hello
    return [200, { "Content-Type" => "application/json" }, [{ :message => "hello world!" }.to_json]]
  end

  def create_game(req)
    game_hash = JSON.parse(req.body.read)
    new_game_instance = Game.create(game_hash)
    return [201, { "Content-Type" => "application/json" }, [new_game_instance.to_json]]
  end

  def create_user_game(req)
    user_game_hash = JSON.parse(req.body.read)
    new_user_game_instance = UserGame.create(user_game_hash)
    return [201, { "Content-Type" => "application/json" }, [new_user_game_instance.to_json]]
  end

  def create_user(req)
    user_hash = JSON.parse(req.body.read)
    new_user_instance = User.create(user_hash)
    return [201, { "Content-Type" => "application/json" }, [new_user_instance.to_json]]
  end

  def send_songs(req)
    #   song_instance_array = Song.all
    #   return [200, { "Content-Type" => "application/json" }, [song_instance_array.to_json]]
    chosen_songs = []
    decades = req.params.select do |param|
      param != "numSongs"
    end

    decades.values.map do |decade|
      decade_selected = decade.to_i
      decade_end = decade_selected + 9
      songs_selected_by_decade = Song.where("year BETWEEN ? AND ?", decade_selected, decade_end)
      songs_selected_by_decade.map do |song_instance|
        chosen_songs << song_instance
      end
    end

    num_songs = req.params["numSongs"].to_i
    # songs_selected_by_decade = Song.all.select do |song_instance|
    #     song_instance.year >= decade_selected && song_instance.year <  decade_selected + 10
    # end
    # songs_selected_by_decade.map do |song_instance|
    #   self.class.chosen_songs << song_instance
    # end
    random_songs = chosen_songs.sample(num_songs)
    return [201, { "Content-Type" => "application/json" }, [random_songs.to_json]]
  end

  def self.chosen_songs
    @@chosen_songs
  end

  def send_points(req)
    # user_id = req.params["id"]
    final_point = JSON.parse(req.body.read)["point"]
    selected_id = req.path.split("/").last.to_i
    final_user = User.find(selected_id).update(point: final_point)
    # User.where()
    return [200, { "Content-Type" => "application/json" }, [{ :message => "Point updated" }.to_json]]
  end

  def send_leaderboard
    leaderboard = User.all.order("point DESC")[0, 10]
    return [201, { "Content-Type" => "application/json" }, [leaderboard.to_json(:only => [:username, :point])]]
  end

  def send_not_found
    return [404, {}, ["Path not found!!!"]]
  end

  def send_users
    User.all
  end
end
