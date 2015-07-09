MusicPlayerAPI = require "musicplayer"
program = require "commander"
pkg = require "../package.json"

homedir = require "os-homedir"
path = require "path"
fs = require "fs"
readline = require "readline-sync"
home = homedir()
config = path.join home, ".musicplayer", "config.json"


checkToken = () ->
  answer = readline.question "What is your token? Get one here: http://r.il.ly/remote \n> "
  try
    fs.mkdirSync path.join home, ".musicplayer"
  catch err
    console.error ""
  conf =
    token: answer
    url: "https://reddit.musicplayer.io"
  fs.writeFileSync config, JSON.stringify(conf, null, 2)
  console.log "Token saved in: ", config
  API = MusicPlayerAPI conf


try
  conf = require config
  API = MusicPlayerAPI conf
catch error
  checkToken()

ok = "👍  OK"
error = (res) ->
  console.error "👎  ", res.message
  checkToken()
  console.log "Now try again"
  process.exit()


program
  .version "#{pkg.version}"
  .command "play"
  .description "Play the song"
  .action (env) ->
    API.play.get (isPlaying) ->
      return error(isPlaying) if isPlaying.status is false
      if isPlaying.data is false
        API.play.post (res) ->
          return error(res) if res.status is false
          console.log ok


program
  .command "pause"
  .alias "stop"
  .description "Pause the song"
  .action (env) ->
    API.play.get (isPlaying) ->
      return error(isPlaying) if isPlaying.status is false
      if isPlaying.data is true
        API.play.post (res) ->
          return error(res) if res.status is false
          console.log ok

program
  .command "toggle"
  .description "Toggle the song"
  .action (env) ->
    API.play.post (res) ->
      return error(res) if res.status is false
      console.log ok

program
  .command "forward"
  .alias "next"
  .description "Next song"
  .action (env) ->
    API.forward.post (res) ->
      return error(res) if res.status is false
      console.log ok

program
  .command "backward"
  .alias "prev"
  .description "Previous song"
  .action (env) ->
    API.backward.post (res) ->
      return error(res) if res.status is false
      console.log ok

program
  .command "state"
  .description "Get player state"
  .action (env) ->
    API.play.get (res) ->
      return error(res) if res.status is false
      console.log "Playing:", res.data

program
  .command "subreddits [subs]"
  .description "Get or set subreddits"
  .action (env) ->
    if env?
      API.subreddits.post {subreddits: env}, (res) ->
        return error(res) if res.status is false
        console.log "Subreddits sent:", res.subreddits
    else
      API.subreddits.get (res) ->
        return error(res) if res.status is false
        console.log "Subreddits:", res.data.join(", ")
  .on "--help", () ->
    console.log """
      Examples:
        $ musicplayer subreddits listentothis+music
        $ musicplayer subreddits atmosphericdnb

        $ musicplayer subreddits
    """

program
  .command "user"
  .description "Get user information"
  .action (env) ->
    API.user.get (res) ->
      return error(res) if res.status is false
      user = res.data
      console.log """
        👤  username         #{user.name}
        🔗  link karma       #{user.link_karma}
        💬  comment karma    #{user.comment_karma}
      """

program
  .command "song"
  .description "Get song information"
  .action (env) ->
    API.song.get (res) ->
      return error(res) if res.status is false
      song = res.data
      console.log """
        🎵  #{song.title}
        👤  /u/#{song.author}
        🌍  /r/#{song.subreddit}

        🎵  type       #{song.type}
        📅  age        #{song.created_ago} ago
        👍  karma      #{song.score}
        🔗  url        #{song.url}
      """

program
  .command "*"
  .description "Help"
  .action () ->
    program.help()

program.parse process.argv
