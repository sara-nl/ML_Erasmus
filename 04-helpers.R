use_multi_cpu <- function(threads) {
    library(tensorflow)
    library(keras)
    k_clear_session()
    config <- tf$ConfigProto(intra_op_parallelism_threads = threads, inter_op_parallelism_threads = threads)
    session = tf$Session(config=config)
    k_set_session(session)
}

load_jena_dataset <- function() {
    library(readr)
    # download.file("https://s3.amazonaws.com/keras-datasets/jena_climate_2009_2016.csv.zip","data/jena_climate_2009_2016.csv.zip")
    # unzip("data/jena_climate_2009_2016.csv.zip", exdir = "data")
    fname <- file.path(data_dir = "data", "jena_climate_2009_2016.csv")
    read_csv(fname)
}

create_sequences_x_y <- function(data, sequence_length, target_shift, step_shift) {
    data <- as.matrix(data)
    start_index = 1
    end_index = dim(data)[1]
    # We assume that the input is in legal ranges
    elements = end_index - start_index + 1
    # our targets are a single data point
    target_len = 1
    single_sequence_length = sequence_length + target_shift + target_len
    number_of_sequences = floor((elements - single_sequence_length)/step_shift) + 1
    
    # Initialise variables we need in the loop
    # We store the index which we should start with in each loop in current_start_index
    current_start_index = start_index
    sequence_x <- array(0, dim = c(number_of_sequences, sequence_length, dim(data)[2]))
    sequence_y <- array(0, dim = c(number_of_sequences, dim(data)[2]))
    for (sequence_index in 1:number_of_sequences) {
        # We get the current sequence data
        sequence_x[sequence_index,,] <- data[current_start_index:(current_start_index+sequence_length-1),]
        sequence_y[sequence_index,] <- data[(current_start_index+sequence_length+target_shift):(current_start_index+sequence_length+target_shift+target_len-1),]
        # We update our next start
        current_start_index <- current_start_index + step_shift
    }
    list(x = sequence_x, y = sequence_y)
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