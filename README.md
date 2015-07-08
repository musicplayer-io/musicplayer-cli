## Music Player CLI

> Command Line Interface for the Music Player

### Installation

```
$ npm install -g musicplayer-cli
````


### Usage

```
Usage: musicplayer [command]


Commands:

  play               Play the song
  pause|stop         Pause the song
  toggle             Toggle the song
  forward|next       Next song
  backward|prev      Previous song
  state              Get player state
  subreddits [subs]  Get or set subreddits
  user               Get user information
  song               Get song information
  *                  Help

Options:

  -h, --help     output usage information
  -V, --version  output the version number
```


#### Examples

```
$ musicplayer song

🎵  Heretoir - To Follow The Sun
👤  /u/Umskiptar
🌍  /r/postrock

🎵  type       youtube
📅  age        36 hours ago
👍  karma      3
🔗  url        https://www.youtube.com/watch?v=qnUGs4vZQ10
```


```
$ musicplayer user

👤  username         illyism
🔗  link karma       6078
💬  comment karma    2739
```


```
$ musicplayer subreddits listentothis+music

Subreddits sent: listentothis+music
```


```
$ musicplayer play
$ musicplayer pause
$ musicplayer toggle

👍  OK
```
