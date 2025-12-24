

local viewPortUtlity = {}


-- Functions for view Port utility
--- Puts the camera into frame [Object = The object [offset = optional custome offset]
function viewPortUtlity.getCamera(object, offset)

    local offset = offset or {
        Vector3.new(0,0,0), --- Offset of the origin
        Vector3.new(0.8,1,0.8), --- Camera Disance amount
    }
    
    -- Gets all the Points in the object
    local pointCloudMax = nil
    local pointCloudMin = nil
    local function  makePointCloud(instance)
        -- Cloud
        if instance:IsA("BasePart") then

            local p = instance.CFrame
            local size = instance.size

            local cornerPositions = {
                Vector3.new( size.X/2,  size.Y/2,  size.Z/2),
                Vector3.new( size.X/2,  size.Y/2, -size.Z/2),
                Vector3.new( size.X/2, -size.Y/2,  size.Z/2),
                Vector3.new( size.X/2, -size.Y/2, -size.Z/2),
                Vector3.new(-size.X/2,  size.Y/2,  size.Z/2),
                Vector3.new(-size.X/2,  size.Y/2, -size.Z/2),
                Vector3.new(-size.X/2, -size.Y/2,  size.Z/2),
                Vector3.new(-size.X/2, -size.Y/2, -size.Z/2),
            }

            for _, corner in pairs(cornerPositions) do
                local objectCorner = CFrame.new(corner):ToObjectSpace(p)
                
                if pointCloudMax == nil then pointCloudMax = objectCorner end
                if pointCloudMin == nil then pointCloudMin = objectCorner end

                pointCloudMin = Vector3.new(
                    math.min(pointCloudMin.X,objectCorner.X),
                    math.min(pointCloudMin.Y,objectCorner.Y),
                    math.min(pointCloudMin.Z,objectCorner.Z)
                )
                 pointCloudMax = Vector3.new(
                    math.max(pointCloudMax.X,objectCorner.X),
                    math.max(pointCloudMax.Y,objectCorner.Y),
                    math.max(pointCloudMax.Z,objectCorner.Z)
                )
            end

        end
        -- Recursion for children
        for _, child in pairs(instance:GetChildren()) do
            makePointCloud(child)
        end
    end

    makePointCloud(object)
    
    -- Retrun Values
    -----> Origin
    local cameraOrigin = Vector3.new(
        (pointCloudMax.X + pointCloudMin.X) / 2 + offset[1].X,
        (pointCloudMax.Y + pointCloudMin.Y)/ 2 + offset[1].Y,
        (pointCloudMax.Z + pointCloudMin.Z) / 2 + offset[1].Z
    )
    ----> Distance
    local cameraDistance = Vector3.new(
        math.abs(pointCloudMax.X - pointCloudMin.X) * offset[2].X,
        math.abs(pointCloudMax.Y -pointCloudMin.Y) / 2.5 * offset[2].Y,
        math.abs(pointCloudMax.Z - pointCloudMin.Z) * offset[2].Z
    )

    return cameraOrigin, cameraDistance
end

return viewPortUtlity
