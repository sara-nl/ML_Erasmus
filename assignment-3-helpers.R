set_thread_count <- function(threads) {
    library(tensorflow)
    library(keras)
    k_clear_session()
    config <- tf$ConfigProto(intra_op_parallelism_threads = threads, inter_op_parallelism_threads = threads)
    session = tf$Session(config=config)
    k_set_session(session)
}

load_activity_dataset <- function() {
    data_dir <- "data"
    dataset_name <- "WISDM_ar_v1.1"
    
    dir.create(data_dir, showWarnings = FALSE)
    destfolder <- file.path(data_dir, dataset_name)
    if (!file.exists(destfolder)) {
        Sys.setenv(TAR = '/bin/tar')
        tarball <- file.path(data_dir, "WISDM_ar_latest.tar.gz")
        download.file("http://www.cis.fordham.edu/wisdm/includes/datasets/latest/WISDM_ar_latest.tar.gz",
                      tarball)
        untar(tarball)
        system(paste("mv", dataset_name, destfolder, sep=" "))
        system("sed 's/;//g' data/WISDM_ar_v1.1/WISDM_ar_v1.1_raw.txt > data/WISDM_ar_v1.1/WISDM_ar_v1.1_raw_cleaned.txt")
    }
    data = read.table(file.path(destfolder, "WISDM_ar_v1.1_raw_cleaned.txt"), sep=",", header=F, fill=TRUE, stringsAsFactors=FALSE)
    
    data <- data[complete.cases(data), ]
    data[, 4] <- as.numeric(data[, 4])
    data[, 5] <- as.numeric(data[, 5])
    data[, 6] <- as.numeric(data[, 6])
    names(data) <- c("UserId", "Activity", "Timestamp", "x-acceleration", "y-acceleration", "z-acceleration")
    data
    
}
load_sunspots_dataset <- function() {
    data = read.table("data/SN_m_tot_V2.0.csv", sep=";", header=F)
    data = data.frame(data[, 1], data[, 2], data[, 4])
    names(data) <- c("Year", "Month", "Mean monthly sunspots")
    data
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
    x_train <- array(x_train, dim = c(dim(x_train)[1], dim(x_train)[2], dim(x_data)[3]))
    x_test <- x_data[test_start_index:test_end_index,,]
    x_test <- array(x_test, dim = c(dim(x_test)[1], dim(x_test)[2], dim(x_data)[3]))
    
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