% Assignmen problem in Minizinc
% Polygamous version
% Model created by Hakan Kjellerstrand, hakank@bonetmail.com
% See also my MiniZinc page: http://www.hakank.org/minizinc
include "alldifferent.mzn";
int: rows;
int: cols;
array[1..rows+1] of int: ks;
%Initializing each husband
array[1..cols] of var 1..cols: men;

%Creating cost array
array[1..rows, 1..cols] of int: cost;

%Objective function
var int: total_cost = 
    sum(i in 1..rows) (
        sum(j in 1+ks[i]..ks[i+1]) (cost[i,men[j]])
        );


% minimize total_cost
solve minimize total_cost;

%
% No wives has two hunbands
%
constraint alldifferent(men);

%
% Magic constraint.  :-)  Michael, can you figure out why I added this one?
%
constraint forall(i in 1..rows) 
           (forall(j in 1+ks[i]..ks[i+1]-1) 
                     (men[j]<men[j+1]));

% Data
rows = 4;
cols = 20;
cost = 
[|14,  5, 8,  7, 15,  7, 3, 15, 8,  4,  2, 16, 7, 3,  4,  1,  8, 2, 5, 11,  
 | 2, 12, 6,  5,  3, 11, 8,  3, 5,  3,  6,  7, 4, 2, 14,  6, 12, 5, 7,  4,
 | 7,  8, 3,  9,  7,  1, 4,  7, 3,  5, 12, 13, 1, 3,  9, 11, 18, 5, 1, 11,
 | 2,  4, 6, 10,  1,  9, 9,  1, 4, 13,  2,  8, 1, 2, 15,  7,  3, 5, 7,  1, 
|]
;

% Instead of the number of wives, ks has the cumulative number of wives.
ks=[0, 6, 9, 16, 20];

output [
  "total_cost: " ++ show(total_cost)++"\n"++show(men)++"\n"
]

