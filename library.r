library(repr)
options(repr.plot.width=6, repr.plot.height=4)


Progress <- R6::R6Class("Progress",
  inherit = KerasCallback,
  
  public = list(
    num_batches = NULL,
    num_epochs  = NULL,
    update_frequency = NULL,
    epoch = NULL,
    batch = NULL,
      
    initialize = function(num_batches, num_epochs, update_frequency) {
        self$num_batches <- num_batches
        self$num_epochs <- num_epochs
        self$update_frequency <- update_frequency
        self$epoch <- 1
    },
                        
    on_batch_end = function(batch, logs = list()) {
        if ((batch + 1) %% self$update_frequency == 0) {
            cat('Epoch ', self$epoch + 1, '/', self$num_epochs, ': ', batch + 1, '/', self$num_batches, 
                ' - loss: ', logs[['loss']], '\r', sep = '')
            flush.console()
        }
        self$batch <- batch
    },
      
    on_epoch_begin = function(epoch, logs = list()) {
        self$epoch <- epoch
    },
                        
    on_epoch_end = function(epoch, logs = list()) {
        cat('Epoch ', self$epoch + 1, '/', self$num_epochs, ': ', self$batch + 1, '/', self$num_batches, 
                ' - loss: ', logs[['loss']], ' - validation loss: ', logs[['val_loss']], '\n', sep = '')
        flush.console()
    }
))
