
projectile={}
projectile.__index= projectile

function projectile:new(x,y,r)
    local instance= setmetatable({},projectile)
    instance.image=love.graphics.newImage("Assets/bullet.png")
    instance.r=r
    instance.speed=8
    instance.x=x
    instance.y=y
    return instance
end

function projectile:MOVE()
    vx=math.cos(self.r - math.pi/2)*self.speed
    vy=math.sin(self.r - math.pi/2)*self.speed
    self.x=(self.x+vx)
    self.y=(self.y+vy)
end

function projectile:getr()
    return self.r
end