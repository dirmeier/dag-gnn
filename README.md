# DAG-GNN

[![Project Status](http://www.repostatus.org/badges/latest/concept.svg)](http://www.repostatus.org/#concept)
[![Build Status](https://travis-ci.org/dirmeier/dag-gnn.svg?branch=master)](https://travis-ci.org/dirmeier/dag-gnn)

> A variational autoencoder to learn the DAG of a structural equations model

## About

DAG-GNN implements a variational autoencoder to learn the DAG of a 
structural equations model in Tensorflow (in R). The the method of the same name 
has been published by [Yu *et al.*](https://arxiv.org/abs/1904.10098) recently.

The basic idea of the method is as simple as beautiful. Cast the structure learning 
problem into a continuous optimization problem using a variational autoencoder
and enforce acyclicity with an equality constraint.

## Installation
 
You can install the packagefrom GitHub

```r
remotes::install_github("dirmeier/dag-gnn")
```

## Author

Simon Dirmeier <a href="mailto:simon.dirmeier @ web.de">simon.dirmeier @ web.de</a>
