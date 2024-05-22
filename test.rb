require 'ruby2d'
require './map.rb'
require './main.rb'

set background: 'white'

$camera = CMap.new(
    playerHeight: 10,
    playerWidth: 10,
    playerX: Window.width/2 - 5,
    playerY: Window.height/2 - 5
)
$camera.rectangle(
    x: 10,
    y: 10,
    width: 100,
    height: 100,
    z: 20,
    color: 'black',
    collision: true,
    opacity: 0.5
)

on :key_held do |event|
    if event.key == "w"
        $camera.collisionMove(0, 5)
    elsif event.key == "a"
        $camera.collisionMove(5, 0)
    elsif event.key == "s"
        $camera.collisionMove(0, -5)
    elsif event.key == "d"
        $camera.collisionMove(-5, 0)
    end
end



show