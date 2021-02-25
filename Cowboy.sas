/*This sas file creates a cowboy hat graphic using proc g3d and some math.*/
goptions cback=black colors=(white cyan red conflict yellow);

data hat;
   do x=-5 to 5 by .25;
      do y=-5 to 5 by .25;
         z=sin(sqrt(x*x + y*y));
         output;
      end;
   end;
run;
title1 c=white f=swiss 'The Cowboy Hat is completely awesome';
title2 h=2 angle=90 ' ';

proc g3d data=hat;
   plot y*x=z / ctop=red ctext=purple;
run; 

/* test */

