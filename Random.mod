IMPLEMENTATION MODULE Random;

CONST
     increment = 0;
     initialseed = 1;
     modulus = 2147483648;
     multiplier = 65539;
     
VAR
    seed : CARDINAL;

PROCEDURE Rand(limit : CARDINAL) :CARDINAL;
BEGIN
    (* TODO - Intermediate value overflow will be thrown? *)
    seed := (seed * multiplier + increment) MOD modulus;
    RETURN seed MOD limit;     
END Rand;

PROCEDURE Srand();
BEGIN
     seed := initialseed;
END Srand;

END Random.
