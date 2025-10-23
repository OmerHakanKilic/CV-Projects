enemy={}
enemy.__index=enemy

function enemy:new(x,y,r)
    local instance= setmetatable({},enemy)
    instance.image=love.graphics.newImage("Assets/enemyship.png")
    instance.r=r
    instance.speed=3
    instance.x=x
    instance.y=y
    return instance
end

function enemy:MOVE()
    vx=5
    vy=math.sin(self.x/180)*self.speed
    self.x=(self.x+vx)
    self.y=self.y+vy
end

function enemy:checkCollision(x,y,enemy_x,enemy_y)
    i=0
    if(x>enemy_x and x<enemy_x+16)
    then
        i=i+1
    end
    if(y>enemy_y and y<enemy_y+16)
    then
        i=i+1
    end
    return i
end