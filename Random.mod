IMPLEMENTATION MODULE Random;

CONST
     increment = 1;
     initialseed = 1;
     modulus = 32768;
     multiplier = 69069;
     
VAR
    seed : CARDINAL;

PROCEDURE Rand(limit : CARDINAL) :CARDINAL;
BEGIN
    (*seed := (seed * multiplier + increment) MOD modulus; 
    RETURN seed MOD limit;*)
    RETURN 0;
END Rand;

PROCEDURE Srand();
BEGIN
     seed := initialseed;
END Srand;

END Random.
