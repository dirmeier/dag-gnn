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


#' @include AllClasses.R


#' @rdname sem-methods
#' @aliases sem,sem_vae-method
setMethod("sem", signature(obj = "sem_vae"), function(obj) obj@sem$sem$numpy())


#' @rdname dataSet-methods
#' @aliases dataSet,sem_vae-method
setMethod("dataSet", signature(obj = "sem_vae"), function(obj) obj@data$numpy())
