
# Thin wrapper around capture.output that also captures warnings and messages
capture_output <- function(expr, capture_warnings = TRUE, capture_messages = TRUE, 
    muffle_warnings = FALSE, muffle_messages = TRUE) {
  utils::capture.output({
    base::withCallingHandlers({
      expr
      }, warning = function(e) {
        if (capture_warnings) cat("Warning: ", conditionMessage(e), "\n")
        if (muffle_warnings) invokeRestart("muffleWarning")
      }, message = function(e) {
        if (capture_messages) cat(e$message, "\n")
        if (muffle_messages) invokeRestart("muffleMessage")
      }
    )
  })
}

