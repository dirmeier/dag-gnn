# DAG-GNN

[![Project Status](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
[![Build Status](https://travis-ci.org/dirmeier/daggnn.svg?branch=master)](https://travis-ci.org/dirmeier/daggnn)

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

Have a look at a sample case [here]().

## Installation

Install the package using:

```r
remotes::install_github("dirmeier/daggnn")
```

## Author

Simon Dirmeier <a href="mailto:simon.dirmeier @ web.de">simon.dirmeier @ web.de</a>
