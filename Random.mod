IMPLEMENTATION MODULE Random;

CONST
     increment = 0;
     initialseed = 1;
     modulus = 262144;
     multiplier = 16087;
     
VAR
    seed : CARDINAL;

PROCEDURE Rand(limit : CARDINAL) :CARDINAL;
BEGIN
    seed := (seed * multiplier + increment) MOD modulus; 
    RETURN seed MOD limit;
END Rand;

PROCEDURE Srand();
BEGIN
     seed := initialseed;
END Srand;

END Random.
