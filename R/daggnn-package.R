# daggnn: a variational autoencoder to learn the DAG of a structural equations model
#
# Copyright (C) 2020 Simon Dirmeier
#
# This file is part of daggnn
#
# daggnn is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# daggnn is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with daggnn If not, see <http://www.gnu.org/licenses/>.


#' @title daggnn
#'
#' @description daggnn implements a variational autoencoder to learn the DAG
#'  of a structural equations model
#'
#' @author Simon Dirmeier
#' @docType package
#' @name daggnn-package
#' @aliases daggnn
#'
#' @references
#'  Yu, Yue and Chen, Jie and Gao, Tian and Yu, Mo (2019). DAG-GNN: DAG Structure
#'  Learning with Graph Neural Networks. ICML
globalVariables(c("%>%", "%as%"))
