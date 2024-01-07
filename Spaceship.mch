MACHINE
    Spaceship
    
SEES
    Space
    
SETS
    REPORT = { MOVE_OK, MOVE_FAIL, BOUNDARY_ERROR, ASTEROID_IMPACT, LOW_POWER, WARP_SUCCESS, WARP_ERROR, WARP_POWER_FAIL, WARP_BOUNDARY_ERROR, ASTEROID_WARP_COLLISION, WARP_LOW_POWER, WARP_TO_STARBASE_BLOCKED, AT_STARBASE, WARP_DRIVE_FAILED_ASTEROID_COLLISION, NOT_AT_STARBASE, GAME_WON, GAME_LOST, GAME_ACTIVE, GAME_ENDED_START_NEW, INITIATE_GAME } ;
    STATUS = { Victory, Defeat, Active }
    
DEFINITIONS
    isInGrid( x_coord, y_coord ) == ( ( x_coord |-> y_coord ) : Grid ) ;
    detectAsteroid( x_coord, y_coord ) == ( ( x_coord |-> y_coord ) : Asteroids )
    
CONSTANTS
    MoveEnergyCost,
    WarpDriveEnergy,
    AsteroidHitPenalty,
    EnergyCapacity
    
PROPERTIES    
    MoveEnergyCost = 5 &
    WarpDriveEnergy = 20 &
    AsteroidHitPenalty = 10 &
    EnergyCapacity = 120

    
VARIABLES
    shipPosX,
    shipPosY,
    energyLevel,
    collisionCounter,
    shipCoord,
    navigationPath,
    currentStatus
    
INVARIANT
    shipPosX : GridXRange &
    shipPosY : GridYRange &
    energyLevel : NAT &
    energyLevel >= 0 & 
    collisionCounter : NAT &
    shipCoord : Grid &
    navigationPath : seq( Grid ) &
    currentStatus : STATUS
    
INITIALISATION
    shipPosX := 1
    || shipPosY := 1
    || energyLevel := 0
    || collisionCounter := 0
    || shipCoord := ( 1 |-> 1 ) 
    || navigationPath := [ (1 |->1 ) ] 
    || currentStatus := Active
    
OPERATIONS
    feedback <-- StartNewGame(inputPower) =
PRE
    inputPower : NAT1 &
    inputPower <= EnergyCapacity
THEN
    energyLevel := inputPower;
    shipPosX := 1;
    shipPosY := 1;
    collisionCounter := 0;
    shipCoord := (1 |-> 1);
    navigationPath := [(1 |-> 1)];
    currentStatus := Active;
    feedback := INITIATE_GAME
END;


    feedback <-- MoveUp = 
    PRE
        feedback : REPORT &
        Active = currentStatus &
        energyLevel >= MoveEnergyCost &
        shipPosY + 1 : GridYRange
    THEN
        IF
            ( Active = currentStatus )
        THEN
            IF
                ( energyLevel >= MoveEnergyCost )
            THEN
                IF
	isInGrid(shipPosX, shipPosY + 1) & not(detectAsteroid(shipPosX, shipPosY + 1))
                THEN
                    shipPosY := shipPosY + 1
                    || energyLevel := energyLevel - MoveEnergyCost
                    || shipCoord := ( shipPosX |-> shipPosY ) 
                    || navigationPath := navigationPath ^ [ shipCoord ]
                    || IF ( shipCoord : Starbase )
                       THEN currentStatus := Victory
                       ELSE currentStatus := Active
                       END
                    || feedback := MOVE_OK
                ELSIF
                    detectAsteroid( shipPosX, shipPosY + 1 )
                THEN
                    IF energyLevel >= AsteroidHitPenalty THEN
                    energyLevel := energyLevel - AsteroidHitPenalty
                    || collisionCounter := collisionCounter + 1
                    || feedback := ASTEROID_IMPACT
                ELSE
                    feedback := LOW_POWER
                END
            ELSE
                feedback := BOUNDARY_ERROR
            END
            ELSE
                currentStatus := Defeat
                || feedback := LOW_POWER
            END
        ELSE 
            feedback := GAME_ENDED_START_NEW
        END
    END;
    
feedback <-- MoveDown =
PRE
    feedback : REPORT &
    Active = currentStatus &
    energyLevel >= MoveEnergyCost &
    shipPosY - 1 : GridYRange
THEN
    IF
        ( Active = currentStatus )
    THEN
        IF
            ( energyLevel >= MoveEnergyCost )
        THEN
            IF
                isInGrid(shipPosX, shipPosY - 1) & not(detectAsteroid(shipPosX, shipPosY - 1))
            THEN
                shipPosY := shipPosY - 1
                || energyLevel := energyLevel - MoveEnergyCost
                || shipCoord := ( shipPosX |-> shipPosY ) 
                || navigationPath := navigationPath ^ [ shipCoord ]
                || IF ( shipCoord : Starbase )
                   THEN currentStatus := Victory
                   ELSE currentStatus := Active
                   END
                || feedback := MOVE_OK
            ELSIF
                detectAsteroid(shipPosX, shipPosY - 1)
            THEN
                IF energyLevel >= AsteroidHitPenalty THEN
                    energyLevel := energyLevel - AsteroidHitPenalty
                    || collisionCounter := collisionCounter + 1
                    || feedback := ASTEROID_IMPACT
                ELSE
                    feedback := LOW_POWER
                END
            ELSE
                feedback := BOUNDARY_ERROR
            END
        ELSE
            currentStatus := Defeat
            || feedback := LOW_POWER
        END
    ELSE 
        feedback := GAME_ENDED_START_NEW
    END
END;



feedback <-- MoveRight =
PRE
    feedback : REPORT &
    Active = currentStatus &
    energyLevel >= MoveEnergyCost &
    shipPosX + 1 : GridXRange
THEN
    IF
        ( Active = currentStatus )
    THEN
        IF
            ( energyLevel >= MoveEnergyCost )
        THEN
            IF
                isInGrid(shipPosX + 1, shipPosY) & not(detectAsteroid(shipPosX + 1, shipPosY))
            THEN
                shipPosX := shipPosX + 1
                || energyLevel := energyLevel - MoveEnergyCost
                || shipCoord := (shipPosX |-> shipPosY)
                || navigationPath := navigationPath ^ [shipCoord]
                || IF (shipCoord : Starbase)
                   THEN currentStatus := Victory
                   ELSE currentStatus := Active
                   END
                || feedback := MOVE_OK
            ELSIF
                detectAsteroid(shipPosX + 1, shipPosY)
            THEN
                IF energyLevel >= AsteroidHitPenalty THEN
                    energyLevel := energyLevel - AsteroidHitPenalty
                    || collisionCounter := collisionCounter + 1
                    || feedback := ASTEROID_IMPACT
                ELSE
                    feedback := LOW_POWER
                END
            ELSE
                feedback := BOUNDARY_ERROR
            END
        ELSE
            currentStatus := Defeat
            || feedback := LOW_POWER
        END
    ELSE 
        feedback := GAME_ENDED_START_NEW
    END
END;


feedback <-- MoveLeft =
PRE
    feedback : REPORT &
    Active = currentStatus &
    energyLevel >= MoveEnergyCost &
    shipPosX - 1 : GridXRange
THEN
    IF
        ( Active = currentStatus )
    THEN
        IF
            ( energyLevel >= MoveEnergyCost )
        THEN
            IF
                isInGrid(shipPosX - 1, shipPosY) & not(detectAsteroid(shipPosX - 1, shipPosY))
            THEN
                shipPosX := shipPosX - 1
                || energyLevel := energyLevel - MoveEnergyCost
                || shipCoord := (shipPosX |-> shipPosY)
                || navigationPath := navigationPath ^ [shipCoord]
                || IF (shipCoord : Starbase)
                   THEN currentStatus := Victory
                   ELSE currentStatus := Active
                   END
                || feedback := MOVE_OK
            ELSIF
                detectAsteroid(shipPosX - 1, shipPosY)
            THEN
                IF energyLevel >= AsteroidHitPenalty THEN
                    energyLevel := energyLevel - AsteroidHitPenalty
                    || collisionCounter := collisionCounter + 1
                    || feedback := ASTEROID_IMPACT
                ELSE
                    feedback := LOW_POWER
                END
            ELSE
                feedback := BOUNDARY_ERROR
            END
        ELSE
            currentStatus := Defeat
            || feedback := LOW_POWER
        END
    ELSE 
        feedback := GAME_ENDED_START_NEW
    END
END;



    feedback <-- EngageWarpDrive(targetX, targetY) = 
PRE
    feedback : REPORT & 
    targetX : NAT1 & targetY : NAT1 & 
    Active = currentStatus &
    energyLevel >= WarpDriveEnergy &
    targetX : GridXRange & targetY : GridYRange
THEN
    IF
        (Active = currentStatus & energyLevel >= WarpDriveEnergy)
    THEN
        IF
            isInGrid(targetX, targetY) & not(detectAsteroid(targetX, targetY))
        THEN
            shipPosX, shipPosY := targetX, targetY
                || shipCoord := ( targetX |-> targetY )
                || energyLevel := energyLevel - WarpDriveEnergy
                || navigationPath := navigationPath ^ [ shipCoord ]
                || IF ( shipCoord : Starbase )
                   THEN currentStatus := Victory
                   ELSE currentStatus := Active
                   END
                || feedback := WARP_SUCCESS
        ELSIF
            detectAsteroid(targetX, targetY)
        THEN
            energyLevel := energyLevel - WarpDriveEnergy
            || feedback := WARP_DRIVE_FAILED_ASTEROID_COLLISION
        ELSE
            feedback := WARP_BOUNDARY_ERROR
        END
    ELSE
        feedback := WARP_POWER_FAIL
    END
END;



    location, power, collisions <-- MissionStatus =
    BEGIN
        location := shipCoord
        || power := energyLevel
        || collisions := collisionCounter
    END;


    path <-- MissionRoute =
    BEGIN
        path := navigationPath
    END;

    feedback <-- DockedAtStarbase =
    PRE
        feedback : REPORT  
    THEN
        IF
            ( shipCoord : Starbase )
        THEN
            feedback := AT_STARBASE
        ELSE
            feedback := NOT_AT_STARBASE
        END
    END;

    feedback <-- GameStatus =
    PRE
        feedback : REPORT  
    THEN
        IF
            ( Victory = currentStatus )
        THEN
            feedback := GAME_WON
        ELSIF
            ( Defeat = currentStatus )
        THEN
            feedback := GAME_LOST
        ELSE
            feedback := GAME_ACTIVE
        END
    END
   
END
