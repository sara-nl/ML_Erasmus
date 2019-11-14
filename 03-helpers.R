use_multi_cpu <- function() {
    library(tensorflow)
    library(keras)
    k_clear_session()
    threads <- 8L
    config <- tf$ConfigProto(intra_op_parallelism_threads = threads, inter_op_parallelism_threads = threads)
    session = tf$Session(config=config)
    k_set_session(session)
}

load_jena_dataset <- function() {
    library(readr)
    download.file("https://s3.amazonaws.com/keras-datasets/jena_climate_2009_2016.csv.zip","data/jena_climate_2009_2016.csv.zip")
    unzip("data/jena_climate_2009_2016.csv.zip", exdir = "data")
    fname <- file.path(data_dir = "data", "jena_climate_2009_2016.csv")
    read_csv(fname)
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