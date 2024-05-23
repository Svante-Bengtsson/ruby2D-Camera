require 'ruby2d'
require './main.rb'

set background: 'white'
set fullscreen: false

$camera = CMap.new(
    playerHeight: 10,
    playerWidth: 10,
    playerX: Window.width/2 - 5,
    playerY: Window.height/2 - 5,
    opacity: 1,
)
$camera.rectangle(
    x: 0,
    y: 0,
    width: 100,
    height: 100,
    z: 20,
    color: 'black',
    collision: true,
    opacity: 0.5
)
$camera.circle(
    x: 160,
    y: 10,
    radius: 20,
    z: 40,
    color: 'blue',
    collision: true,
    opacity: 1
)
$camera.img(
    url: 'bild.jpg',
    x: 300,
    y: 0,
    width: 100,
    height: 100,
    z: 20,
    collision: true,
)
ball = MovableRectangle.new(
    $camera,
    y: -120,
    width: 120,
    height: 30
)

$camera.rectangle(
    x: 0,
    y: -145,
    width: 100,
    height: 100,
    z: 20,
    color: 'gray',
    collision: true,
    opacity: 1
)
$camera.rectangle(
    x: 200,
    y: -145,
    width: 100,
    height: 100,
    z: 20,
    color: 'gray',
    collision: true,
    opacity: 1
)
check = 0

on :key_held do |event|
    if event.key == "w"
        $camera.collisionMove(0, 5)
    elsif event.key == "a"
        $camera.collisionMove(5, 0)
    elsif event.key == "s"
        $camera.collisionMove(0, -5)
    elsif event.key == "d"
        $camera.collisionMove(-5, 0)
    elsif event.key == 'space'
        if check == 3
            check = 2
        elsif check == 4
            check = 0
        end
    end
end
tick = 0
update do
    if tick % 2 == 0
        if check == 0
            ball.move(2, 0, $camera)
            if ball.getX($camera) == 100
                check = 3
            end
        elsif check == 2
            ball.move(-2, 0, $camera)
            if ball.getX($camera) == 0
                check = 4
            end
        end
    end
    tick += 1
end


show