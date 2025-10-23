player={}
player.__index=player

function player:new()
    local self=setmetatable({},player)
    self.x=1000
    self.y=600
    self.r=0
    self.image=love.graphics.newImage("Assets/ship.png")
    return self
end

function player:calcPlayerRotation()
    rotation=math.atan2((mouse_y-p.y),(mouse_x-p.x))
    self.r=rotation+math.pi/2
end

function player:dash()

end

