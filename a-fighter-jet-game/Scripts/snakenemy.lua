snakenemy={}
snakenemy.__index=snakenemy

function snakenemy:new(x,y,r)
    local instance= setmetatable({},snakenemy)
    instance.image=love.graphics.newImage("Assets/snakeship.png")
    instance.r=r
    instance.speed=5
    instance.x=x
    instance.y=y
    return instance
end

function snakenemy:MOVE()
    vy=3
    self.y=self.y+vy
end

function snakenemy:checkCollision(x,y,snakenemy_x,snakenemy_y)
    i=0
    if(x>snakenemy_x and x<snakenemy_x+16)
    then
        i=i+1
    end
    if(y>snakenemy_y and y<snakenemy_y+16)
    then
        i=i+1
    end
    return i
end