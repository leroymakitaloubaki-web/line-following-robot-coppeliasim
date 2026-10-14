function sysCall_init()
    -- Initialisation des objets avec chemins absolus
    leftJoint   = sim.getObject('/DynamicLeftJoint')
    rightJoint  = sim.getObject('/DynamicRightJoint')
    leftSensor  = sim.getObject('/LeftSensor')
    rightSensor = sim.getObject('/RightSensor')
    
    print("Initialisation termin?e : Moteurs et Capteurs pr?ts !")
end

function sysCall_actuation()
    -- 1. Lecture des capteurs pour la logique de mouvement
    local resultL, data_left = sim.readVisionSensor(leftSensor)
    local resultR, data_right = sim.readVisionSensor(rightSensor)
    
    -- Variables de vitesse
    v = 2   -- Vitesse de base
    dv = 2  -- Acc?l?ration pour le virage
    
    -- Vitesse par d?faut : on avance tout droit
    local vLeft = v
    local vRight = v

    -- 2. Logique de d?cision bas?e sur l'intensit? (Index 11 = Rouge/Intensit?)
    if (data_left ~= nil and data_right ~= nil) then
        local intensity_left  = data_left[11]
        local intensity_right = data_right[11]

        -- Si le capteur DROIT voit du blanc (>0.5) et le GAUCHE voit du noir (<0.5)
        if (intensity_right > 0.5 and intensity_left < 0.5) then
            print("Turn Left")
            vRight = v + dv -- On booste la roue droite pour tourner ? gauche
        end

        -- Si le capteur GAUCHE voit du blanc (>0.5) et le DROIT voit du noir (<0.5)
        if (intensity_left > 0.5 and intensity_right < 0.5) then
            print("Turn Right")
            vLeft = v + dv -- On booste la roue gauche pour tourner ? droite
        end
    end

    -- 3. Application des vitesses
    sim.setJointTargetVelocity(leftJoint, vLeft)
    sim.setJointTargetVelocity(rightJoint, vRight)
end

function sysCall_sensing()
    -- Affichage RGB pour le d?bug (Image image_6f33de.jpg)
    local resL, data_L = sim.readVisionSensor(leftSensor)
    if (data_L ~= nil) then
        print(string.format("GAUCHE - R:%.2f G:%.2f B:%.2f", data_L[11], data_L[12], data_L[13]))
    end
end
