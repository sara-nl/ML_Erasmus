## Plotting functions

plot_predictions <- function(X, y, neuron) {
    library(repr)
    library(grid)
    library(gridExtra)
    library(directlabels)
    library(latex2exp)
    options(repr.plot.width = 8, repr.plot.height = 3.5)
    
    maxes <- round(apply(X, 2, max))
    
    grid <- expand.grid(
        x1 = seq(-1, maxes[[1]], length.out = 100),
        x2 = seq(-1, maxes[[2]], length.out = 100)
    )
    y_hat <- c(neuron(as.matrix(grid)))
    grid <- cbind(grid, probability = y_hat, y_pred = as.factor(as.numeric(y_hat > 0.5)))
    y_pred <- c(neuron(X))
    
    df <- data.frame(x1 = X[,1], x2 = X[,2], y = y)

    num_correct <- sum((y_pred > .5) * 1 + 1 == as.numeric(df$y))
    accuracy <- num_correct / length(y)
    
    p1 <- ggplot() +
        theme_minimal() +
        scale_fill_gradient(low = "white", high = "orange") +
        theme(legend.position = "left") + 
        geom_tile(data = grid, aes(x = x1, y = x2, fill = probability)) +
        geom_point(data = df, aes(x = x1, y = x2, colour = y)) +
        geom_vline(xintercept = 0, color = 'gray', linetype = 'dashed') +
        geom_hline(yintercept = 0, color = 'gray', linetype = 'dashed') +
        xlim(-1, maxes[[1]]) +
        ylim(-1, maxes[[2]]) +
        xlab(TeX('$x_1$')) +
        ylab(TeX('$x_2$')) +
        geom_point(data = df, aes(x = x1, y = x2, stroke = "white"), shape = 21, stroke = .5) +
        ggtitle('Probability of y = 1')

    p2 <- ggplot() +
        theme_minimal() +
        theme(legend.position = "none") +
        geom_tile(data = grid, aes(x = x1, y = x2, fill = y_pred)) +
        geom_point(data = df, aes(x = x1, y = x2, colour = as.factor(y))) +
        geom_point(data = df, aes(x = x1, y = x2, stroke = "white"), shape = 21, stroke = .5) +
        geom_vline(xintercept = 0, color = 'gray', linetype = 'dashed') +
        geom_hline(yintercept = 0, color = 'gray', linetype = 'dashed') +
        xlim(-1, maxes[[1]]) +
        ylim(-1, maxes[[2]]) +
        xlab(TeX('$x_1$')) +
        ylab(TeX('$x_2$')) +
        ggtitle(paste('Decision boundary (acc. = ', accuracy, ')', sep = ''))

    grid.arrange(p1, p2, layout_matrix = matrix(c(1, 1, 1, 1, 2, 2, 2), nrow = 1))
}

## Data set functions

create_linear_dataset <- function() {
    library(MASS)
    set.seed(0)
    
    negative <- mvrnorm(n = 25, mu = c(0.25, 0.33), Sigma = matrix(c(0.01, 0, 0, 0.01), 2, 2))
    positive <- mvrnorm(n = 25, mu = c(0.75, 0.66), Sigma = matrix(c(0.01, 0, 0, 0.01), 2, 2))

    x1 <- pmin(1, pmax(0, c(negative[,1], positive[,1])))
    x2 <- pmin(1, pmax(0, c(negative[,2], positive[,2])))
    y  <- as.factor(c(rep(0, 25), rep(1, 25)))

    X <- cbind(x1, x2)
    save(X, y, file = "data/linear-problem.rda")
}

dataset_linear <- function () {
    tmp <- new.env()
    load(envir = tmp, file = "data/linear-problem.rda")
    list(X = tmp$X, y = tmp$y)
}

dataset_xor <- function() {
    list(
        X = matrix(c(c(0, 0, 1, 1), c(0, 1, 0, 1)), nrow = 4),
        y = as.factor(c(0, 1, 1, 0))
    )
}

plot_dataset <- function (X, y) 
{
    library(ggplot2)
    library(latex2exp)
    library(repr)
    options(repr.plot.width = 4, repr.plot.height = 3)
    
    df <- data.frame(x1 = X[, 1], x2 = X[, 2], y = y)
    
    ggplot(df, aes(x1, x2, colour = y)) +
        theme_minimal() +
        geom_point() +
        labs(x = TeX("$x_1$"), y = TeX("$x_2$"))
}
