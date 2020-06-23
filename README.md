# DAG-GNN

[![Project Status](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
[![Build Status](https://travis-ci.org/dirmeier/dag-gnn.svg?branch=master)](https://travis-ci.org/dirmeier/dag-gnn)

> A variational autoencoder to learn the DAG of a structural equations model

## About

DAG-GNN implements a variational autoencoder to learn the DAG of a 
structural equations model in Tensorflow (in R). The the method of the same name 
has been published by [Yu *et al.*](https://arxiv.org/abs/1904.10098) recently.

The basic idea of the method is as simple as beautiful. Cast the structure learning 
problem into a continuous optimization problem using a variational autoencoder
and enforce acyclicity with an equality constraint.

**CAUTION**: I package is work in progress. Sofar I haven't managed to get 
improved estimates of the DAGs as described in the original publication. 

You can find a case study that compares DAG-GNN with the PC-algorithm and
a score-based approach to learn the structure of a causal Bayes net
[here](https://dirmeier.github.io/dag-gnn/index.html). 

## Installation
 
The relevant code that is used in this case study is implemented as an R-package. You can install it using the latest GitHub 
[release](https://github.com/dirmeier/dag-gnn/releases/):

```r
remotes::install_github("dirmeier/dag-gnn@v0.1.0")
```

## Author

Simon Dirmeier <a href="mailto:simon.dirmeier @ web.de">simon.dirmeier @ web.de</a>
