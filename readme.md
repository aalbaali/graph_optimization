# What the repository contains so far
1. Abstract `BaseNode` class and implementations of it including
   1. `NodeSE2`, and
   2. `NodeRn`.
2. Abstract `FactorGraph` class and implementation of it including
   1. `FactorSE2`,
   2. `FactorSE2Meas` (measurements on `SE2` nodes),
   3. `FactorSE2SE2` to model `SE2` process models,
   4. `FactorRn`, 
   5. `FactorRnRn`.
3. A `LieGroups` abstract class that can be inherited with `BaseNode` or `BaseFactor` classes.
4. A `FactorGraph` class that uses custom node and implements a factor graph.
5. A `GraphOptimizer` that optimizes over the provided factor graph.
6. Some examples demonstrating the usage of these classes. Mainly, using the `GraphOptimizer` class. 


# To be done
## General
- [ ] Write a graph post-processing class. Ideally, we'd plot the node locations based on the actual position of the robot. Furthermore, covariance ellipses can be added!
   
## `BaseNode` and derived classes
- [ ] Maybe change the name from `BaseNode` to `VariableNode` since a `BaseFactor` is also a node. The reason for such weird naming is that I recently changed the `BaseFactor` name from `BaseEdge` and decided to treat factors as nodes (as should be) rather than treating them as edges.
- [ ] Write unit tests for each node.
## `BaseFactor` and derived classes
- [ ] Write unit tests for factor node. Try automating the unit test (for the derivatives at least).

## `FactorGraph`
- [ ] Optimize the performance of the factor graph. Specifically, the `node` function; it takes a long time.
## `GraphOptimizer`
- [ ] improve performance for large number of nodes.