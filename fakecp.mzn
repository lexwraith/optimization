%
% Assignmen problem in Minizinc
% 
% Winston "Operations Research", Assignment Problems, page 393f
%
% (generalized version with added test column)
%
% Model created by Hakan Kjellerstrand, hakank@bonetmail.com
% See also my MiniZinc page: http://www.hakank.org/minizinc

int: rows;
int: cols;

array[1..rows] of int:K;
array[1..rows] of var 1..8: maxwives;
array[1..rows, 1..cols] of var 0..1: x;
array[1..rows, 1..cols] of int:  cost;
var int: total_cost = sum(i in 1..rows, j in 1..cols) (x[i,j]*cost[i,j]);

% minimize total_cost
solve minimize total_cost;

%
% exacly one assignment per row, all rows must be assigned
%
constraint  
 forall(i in 1..rows) 
(
        sum(j in 1..cols) (x[i,j]) = K[i]
)
;

%maxwives must sum up to total number of wives
%constraint
% forall(i in 1..rows) 
%(
%	sum(j in 1..cols) (x[i,j])= K[i]
%)
%;

% zero or one assignments per column
constraint 
  forall(j in 1..cols) 
(
        sum(i in 1..rows) (x[i,j]) <= 1
)
;


%rows = 4;
%cols = 20;

% added the fifth column
%cost = 
%[|14,  5, 8,  7, 15,  7, 3, 15, 8,  4,  2, 16, 7, 3,  4,  1,  8, 2, 5, 11,  
% | 2, 12, 6,  5,  3, 11, 8,  3, 5,  3,  6,  7, 4, 2, 14,  6, 12, 5, 7,  4,
% | 7,  8, 3,  9,  7,  1, 4,  7, 3,  5, 12, 13, 1, 3,  9, 11, 18, 5, 1, 11,
% | 2,  4, 6, 10,  1,  9, 9,  1, 4, 13,  2,  8, 1, 2, 15,  7,  3, 5, 7,  1, 
%|]
%;
% maxwives array
%K =[6,3,7,4];
output [
  if i = 1 /\ j = 1 then
    "total_cost: " ++ show(total_cost) 
  else " " endif ++
  if j = 1 then "\n" else " " endif ++
  show(x[i,j])
  | i in 1..rows, j in 1..cols
] ++ ["\n"];

