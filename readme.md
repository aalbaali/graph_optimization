# Done so far
1. Wrote a `BaseNode` abstract class handle that will serve as the "variables" to solve for. This includes an `oplus` operator that implements a customized addition.
2. Implemented a `NodeR2` class derived handle from the `BaseNode` class. This implements a class for a variable living in a 2D Euclidean space.
3. Wrote a `BaseFactor` abstract class handle. Derived classes are meant to implement *factors*. 
4. Implemented a `FactorR2R2` class handle derived from `BaseFactor`. This type of factor is a constraint in 2D Euclidean space (for example, a process model for the nodes in 2D space).
5. Wrote a `FactorGraph` class handle that implements a factor graph. It uses nodes derived from `BaseNode` and `BaseFactor`.

# To be done
## General
1. Write an optimization class that takes a factor graph and computes that MAP estimate.
2. Write a graph plotter class. We can plot the node locations based on the actual position of the robot. Furthermore, covariance ellipses can be added!

## `BaseNode` and derived classes
1. Maybe change the name from `BaseNode` to `VariableNode` since a `BaseFactor` is also a node. The reason for such weird naming is that I recently changed the `BaseFactor` name from `BaseEdge` and decided to treat factors as nodes (as should be) rather than treating them as edges.
2. Write unit tests for each node.
## `BaseFactor` and derived classes
1. Write unit tests for the `FactorGraph` class.
2. Write unit tests for factor node. Try automating the unit test (for the derivatives at least).