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


#' @title Plot a simulated data set
#'
#' @export
#' @method plot sem_vae
#'
#' @import ggplot2
#' @import ggraph
#' @importFrom rlang .data
#' @importFrom igraph graph_from_adjacency_matrix
#'
#' @param x a \code{sem_vae} object
#' @param ... additional arguments passed to \code{ggplot2}
#'
plot.sem_vae <- function(x, ...) {
  adj <- sem(x)

  cols <- colnames(dataSet(x))
  if (is.null(cols))
    cols <- seq(ncol(dataSet(x)))
  colnames(adj) <- rownames(adj) <- cols

  igraph::graph_from_adjacency_matrix(adj, weighted = TRUE) %>%
    ggraph::ggraph(layout = "stress") +
    ggraph::geom_edge_link(
      ggplot2::aes(
        color = .data$weight,
        start_cap = label_rect(.data$node1.name),
        end_cap = label_rect(.data$node2.name)
      ),
      arrow = arrow(length = unit(4, "mm"))
    ) +
    ggraph::geom_node_text(ggplot2::aes(label = .data$name), size = 3) +
    ggraph::scale_edge_color_viridis("Coefficient", end = .8, option = "B") +
    ggraph::scale_edge_width("Direction", range = c(.5, 2), limits = c(.5, 1)) +
    ggraph::theme_graph()
}
