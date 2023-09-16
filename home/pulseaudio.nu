def "pulse sinks" [] {
  pactl -f json list sinks | from json | select index name description state volume
}
