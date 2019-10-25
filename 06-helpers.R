use_multi_cpu <- function(threads) {
    library(tensorflow)
    library(keras)
    k_clear_session()
    config <- tf$ConfigProto(intra_op_parallelism_threads = threads, inter_op_parallelism_threads = threads)
    session = tf$Session(config=config)
    k_set_session(session)
}

split_dataset <- function(x_data, y_data, fraction = 0.2) {
    train_start_index <- 1
    train_end_index <- train_start_index + floor((1-fraction) * dim(x_data)[1]) - 1
    test_start_index <- train_end_index + 1
    test_end_index <- dim(x_data)[1]
    
    x_train <- x_data[train_start_index:train_end_index,,]
    x_test <- x_data[test_start_index:test_end_index,,]
    
    y_train <- y_data[train_start_index:train_end_index]
    y_test <- y_data[test_start_index:test_end_index]
    
    list(x_train = x_train,
        y_train = y_train,
        x_test = x_test,
        y_test = y_test)
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