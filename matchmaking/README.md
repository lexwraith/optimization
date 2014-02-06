#Problems#

###Partitioning a Complete Graph into K Complete Sub Graphs###
This is the hard one. There are algorithms out there, but how do I transform
the process into a constraint under GLPK? The end product must be a linear
equation. I can't seem to make matches mutual/inclusive.


####Partitioning V into V/K where V%K!= 0####
This is a sub problem of the previous. The problem gets more interesting when
Complete Graph G can't be partitioned into balanced graphs. A heuristic of
any sort will suffice for this real problem.


###Matchmaking (1 to 1) with an uneven number of candidates###
I've currently alleviated this problem by allowing people to match with themselves.


###Matchmaking with a "floor" for bad match###
This, strangely enough, has created no-solution situations. The constraint I wrote
must be broken. It is currently:
For some i, for all j, the aggregate sum of c[i][j] * x[i][j] > the minimum of the set of c[i][j]


#Ideas#
I'm thinking about forgetting the linear solver and switchin to a genetic
algorithm approach. I'll construct a graph consisted of independent partitions
using DEAP and then use Sage to sum up the edges and give feedback back to
DEAP. This doesn't promise me an optimal solution, but good enough might
suffice.
