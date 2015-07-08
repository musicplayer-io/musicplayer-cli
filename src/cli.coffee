#!/usr/bin/env node

MusicPlayerAPI = require "musicplayer-api"
program = require "commander"
pkg = require "../package.json"

homedir = require "os-homedir"
path = require "path"
fs = require "fs"
readline = require "readline"
home = homedir()
config = path.join home, ".musicplayer", "config.json"

try
  conf = require config
catch error
  rl = readline.createInterface
    input: process.stdin,
    output: process.stdout
  rl.question "What is your token? Get one here: http://r.il.ly/remote \n> ", (answer) ->
    fs.mkdir path.join home, ".musicplayer"
    conf =
      token: answer
      url: "https://reddit.musicplayer.io"
    fs.writeFileSync config, JSON.stringify(conf, null, 2)
    console.log "Token saved in: ", config
    rl.close()

API = MusicPlayerAPI conf

program
  .version "#{pkg.version}"
  .command "play"
  .description "Play the song"
  .action (env) ->
    API.play.get (isPlaying) ->
      return console.log isPlaying.message if isPlaying.status is false
      if isPlaying.data is false
        API.play.post (res) ->
          return console.log res.message if res.status is false
          console.log "OK"


program
  .command "pause"
  .alias "stop"
  .description "Pause the song"
  .action (env) ->
    API.play.get (isPlaying) ->
      return console.log isPlaying.message if isPlaying.status is false
      if isPlaying.data is true
        API.play.post (res) ->
          return console.log res.message if res.status is false
          console.log "OK"

program
  .command "toggle"
  .description "Toggle the song"
  .action (env) ->
    API.play.post (res) ->
      return console.log res.message if res.status is false
      console.log "OK"

program
  .command "forward"
  .alias "next"
  .description "Next song"
  .action (env) ->
    API.forward.post (res) ->
      return console.log res.message if res.status is false
      console.log "OK"

program
  .command "backward"
  .alias "previous"
  .description "Previous song"
  .action (env) ->
    API.backward.post (res) ->
      return console.log res.message if res.status is false
      console.log "OK"

program
  .command "state"
  .description "Get player state"
  .action (env) ->
    API.play.get (isPlaying) ->
      return console.log isPlaying.message if isPlaying.status is false
      console.log "Playing:", isPlaying.data

program
  .command "subreddits [subs]"
  .description "Get or set subreddits"
  .action (env) ->
    if env?
      API.subreddits.post {subreddits: env}, (res) ->
        console.log "Subreddits sent:", res.subreddits
    else
      API.subreddits.get (res) ->
        console.log "Subreddits:", res.data.join(", ")

program
  .command "user"
  .description "Get user information"
  .action (env) ->
    API.user.get (res) ->
      return console.log res.message if res.status is false
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
      return console.log res.message if res.status is false
      song = res.data
      console.log """
        👤  author     #{song.author}
        🌍  subreddit  #{song.subreddit}
        🎵  type       #{song.type}
        📅  age        #{song.created_ago} ago
        👍  karma      #{song.score}
        🔗  url        #{song.url}
      """




program.parse process.argv
