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
