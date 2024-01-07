MACHINE
    Space

CONCRETE_CONSTANTS
    GridXRange,
    GridYRange,
    Grid,
    Homebase,
    Starbase,
    Asteroids

PROPERTIES
    GridXRange = 1..12 &  
    GridYRange = 1..7 &   
    Grid = {xx,yy | xx : GridXRange & yy : GridYRange} &  
    Asteroids <: Grid &   
    Asteroids = { (3 |-> 2), (3 |-> 5), (5 |-> 4), (6 |-> 7), (7 |-> 1), (7 |-> 5), (7 |-> 7), (8 |-> 3), (10 |-> 6), (11 |-> 2), (12 |-> 5) } &
    Homebase <: Grid &    
    Homebase = { (1 |-> 1) } &
    Starbase <: Grid &    
    Starbase = { (6 |-> 4) }

DEFINITIONS
    GRID == POW(NAT1 * NAT1); /* Set of all possible coordinates */

END
