use_multi_cpu <- function() {
    library(tensorflow)
    library(keras)
    k_clear_session()
    threads <- 8L
    config <- tf$ConfigProto(intra_op_parallelism_threads = threads, inter_op_parallelism_threads = threads)
    session = tf$Session(config=config)
    k_set_session(session)
}

plot_predictions_keras <- function(X, y, model) {
    library(repr)
    library(grid)
    library(gridExtra)
    library(directlabels)
    library(latex2exp)
    options(repr.plot.width = 8, repr.plot.height = 3.5)

    mins <- apply(X, 2, min)
    maxes <- apply(X, 2, max)
    range <- maxes - mins
    mins <- mins - 0.1 * range[[1]]
    maxes <- maxes + 0.1 * range[[2]]

    grid <- expand.grid(
        x1 = seq(mins[[1]], maxes[[1]], length.out = 100),
        x2 = seq(mins[[1]], maxes[[2]], length.out = 100)
    )

    y_hat_grid <- model %>% predict(as.matrix(grid))
    grid <- cbind(grid, probability = y_hat_grid, y_pred = as.factor(as.numeric(y_hat_grid > 0.5)))

    df <- data.frame(x1 = X[,1], x2 = X[,2], y = y)

    y_hat <- model %>% predict(X)
    num_correct <- sum((y_hat > .5) * 1 + 1 == as.numeric(df$y))
    accuracy <- num_correct / length(y)

    p1 <- ggplot() +
        theme_minimal() +
        scale_fill_gradient(low = "white", high = "orange") +
        theme(legend.position = "left") + 
        geom_tile(data = grid, aes(x = x1, y = x2, fill = probability)) +
        geom_point(data = df, aes(x = x1, y = x2, colour = y)) +
        geom_vline(xintercept = 0, color = 'gray', linetype = 'dashed') +
        geom_hline(yintercept = 0, color = 'gray', linetype = 'dashed') +
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
        xlab(TeX('$x_1$')) +
        ylab(TeX('$x_2$')) +
        ggtitle(paste('Dec. boundary - acc. = ', accuracy, sep = ''))

    grid.arrange(p1, p2, layout_matrix = matrix(c(1, 1, 1, 1, 2, 2, 2), nrow = 1))
}

create_extended_xor_dataset <- function() {
    library(MASS)
    set.seed(1)
    
    v <- 0.08
    negative1 <- mvrnorm(n = 50, mu = c(0, 0), Sigma = matrix(c(v, 0, 0, v), 2, 2))
    negative2 <- mvrnorm(n = 50, mu = c(1, 1), Sigma = matrix(c(v, 0, 0, v), 2, 2))
    positive1 <- mvrnorm(n = 50, mu = c(1, 0), Sigma = matrix(c(v, 0, 0, v), 2, 2))
    positive2 <- mvrnorm(n = 50, mu = c(0, 1), Sigma = matrix(c(v, 0, 0, v), 2, 2))

    x1 <- c(negative1[,1], negative2[,1], positive1[,1], positive2[,1])
    x2 <- c(negative1[,2], negative2[,2], positive1[,2], positive2[,2])
    y  <- as.factor(c(rep(0, 100), rep(1, 100)))
    
    X <- cbind(x1, x2)
    save(X, y, file = "data/extended-xor-problem.rda")
    list(X, y)
}


dataset_extended_xor <- function () {
    tmp <- new.env()
    load(envir = tmp, file = "data/extended-xor-problem.rda")
    list(X = tmp$X, y = tmp$y)
}

create_checkerboard_dataset <- function () {
    library(MASS)
    set.seed(1)

    nrows <- 4
    ncols <- 4
    v <- 0.08
    data <- c()

    for (i in 1:nrows) {
        for (j in 1:ncols) {
            label <- (i + j) %% 2
            data <- rbind(
                data,
                cbind(
                    mvrnorm(n = 50, mu = c(i, j), Sigma = matrix(c(v, 0, 0, v), 2, 2)),
                    rep(label, 50)
                )
            )
        }
    } 

    X <- data[,1:2]
    y <- as.factor(data[,3])
    save(X, y, file = "data/checkerboard-problem.rda")
    list(X, y)
}


dataset_checkerboard <- function () {
    tmp <- new.env()
    load(envir = tmp, file = "data/checkerboard-problem.rda")
    list(X = tmp$X, y = tmp$y)
}


dataset_checkerboard_validation <- function () {
    tmp <- new.env()
    load(envir = tmp, file = "data/checkerboard-problem-validation.rda")
    list(X = tmp$X, y = tmp$y)
}


dataset_mnist_binary <- function() {
    library(keras)
    data <- dataset_mnist()
    data_train <- data$train
    data_test <- data$test
    
    x_train <- data_train$x[data_train$y == 4 | data_train$y == 9,,]
    y_train <- data_train$y[data_train$y == 4 | data_train$y == 9]
    y_train[y_train == 4] = 0
    y_train[y_train == 9] = 1

    x_test <- data_test$x[data_test$y == 4 | data_test$y == 9,,]
    y_test <- data_test$y[data_test$y == 4 | data_test$y == 9]
    y_test[y_train == 4] = 0
    y_test[y_train == 9] = 1

    list(train = list(x = x_train, y = y_train), test = list(x = x_test, y = y_test))
}

dataset_fashion_mnist_binary <- function() {
    library(keras)
    data <- dataset_fashion_mnist()
    data_train <- data$train
    data_test <- data$test
    
    label1 <- 2
    label2 <- 4
    
    x_train <- data_train$x[data_train$y == label1 | data_train$y == label2,,]
    y_train <- data_train$y[data_train$y == label1 | data_train$y == label2]
    y_train[y_train == label1] = 0
    y_train[y_train == label2] = 1

    x_test <- data_test$x[data_test$y == label1 | data_test$y == label2,,]
    y_test <- data_test$y[data_test$y == label1 | data_test$y == label2]
    y_test[y_test == label1] = 0
    y_test[y_test == label2] = 1

    list(train = list(x = x_train, y = y_train), test = list(x = x_test, y = y_test))
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


Progress <- R6::R6Class("Progress",
  inherit = KerasCallback,
  
  public = list(
    num_epochs  = NULL,
    update_frequency = NULL,
    epoch = NULL,
    batch = NULL,
      
    initialize = function() {
        self$epoch <- 1
    },
      
    on_epoch_end = function(epoch, logs = list()) {
        validation_info <- ''
        if ('val_loss' %in% names(logs))
            validation_info <- paste(', val loss: ', logs[['val_loss']], ', val acc.: ', logs[['val_acc']], sep = '')
        cat('Epoch ', epoch + 1, ' - loss: ', logs[['loss']], ', acc.: ', logs[['acc']], validation_info, '  \r', sep = '')
        flush.console()
    }
))