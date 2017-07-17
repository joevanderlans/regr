#' Replicate STATA Regressions
#'
#' `reg` replicates STATA regressions including regressions with robust standard
#' errors and clustered standard errors.
#'
#' @param formula A formula providing the specifications for your model.
#' @param data A data frame on which to run your regression.
#' @param robust A logical value to indicate if the model should use robust
#'   standard errors.
#' @param cluster A character vector to specify up to two variables by which
#'   to cluster standard errors.
#'
#' @return A data frame with one row for each independent variable and columns
#'   containing the estimated coefficients and the associated standard errors,
#'   t-statistics, and p-values.
#'
#' @examples
#' reg(y ~ x, my_data, robust = TRUE)
#' reg(y ~ x, my_data, cluster = "variable")
#' reg(y ~ x, my_data, cluster = c("variable_1", "variable_2"))

reg <- function(formula, data, robust = FALSE, cluster = NULL) {
  # Create the foundational linear model
  model <- lm(formula, data)

  if (length(cluster) >= 3) {
    # Stop if the user inputs more than two variables by which to cluster
    stop("This function only clusters standard errors for up to two variables.")

  } else if (robust == TRUE & length(cluster) >= 1) {
    # Stop if the user uses robust and cluster
    stop("This function does facilitate robust and clustered standard errors.")

  } else if (robust == FALSE & is.null(cluster)) {
    # If neither robust nor cluster use ordinary OLS
    reg_vcov <- NULL

  } else if (robust == TRUE & is.null(cluster)) {
    # Calculate the HC1 vcov matrix which matches STATA's robust command
    reg_vcov <- sandwich::vcovHC(model, "HC1")

  } else if (robust == FALSE & length(cluster) == 1) {
    # Calculate the vcov matrix adjusting for clustering by one variable
    M <- nrow(unique(data[cluster]))
    N <- nrow(data)
    K <- model[["rank"]]
    dfc <- (M / (M - 1)) * ((N - 1) / (N - K))
    u <- apply(sandwich::estfun(model), 2,
               function(x) tapply(x, data[cluster], sum))
    reg_vcov <- dfc * sandwich::sandwich(model, meat = crossprod(u) / N)

  } else if (robust == FALSE & length(cluster) == 2) {
    # Calculate the vcov matrix adjusting for clustering by two variables
    M1 <- nrow(unique(data[cluster[1]]))
    M2 <- nrow(unique(data[cluster[2]]))
    M12 <- nrow(unique(data[cluster]))
    N <- nrow(data)
    K <- model[["rank"]]
    dfc1 <- (M1 / (M1 - 1)) * ((N - 1) / (N - K))
    dfc2 <- (M2 / (M2 - 1)) * ((N - 1) / (N - K))
    dfc12 <- (M12 / (M12 - 1)) * ((N - 1) / (N - K))
    u1 <- apply(sandwich::estfun(model), 2,
                function(x) tapply(x, data[cluster[1]], sum))
    u2 <- apply(sandwich::estfun(model), 2,
                function(x) tapply(x, data[cluster[2]], sum))
    cluster1 <- as.numeric(as.factor(data[[cluster[1]]]))
    cluster2 <- as.numeric(as.factor(data[[cluster[2]]]))
    cluster12 <- paste(cluster1, cluster2, sep = "_")
    u12 <- apply(sandwich::estfun(model), 2,
                 function(x) tapply(x, cluster12, sum))
    vc1 <- dfc1 * sandwich::sandwich(model, meat = crossprod(u1) / N)
    vc2 <- dfc2 * sandwich::sandwich(model, meat = crossprod(u2) / N)
    vc12 <- dfc12 * sandwich::sandwich(model, meat = crossprod(u12) / N)
    reg_vcov <- vc1 + vc2 - vc12
  }

  # Create a data frame to export
  model_coeftest <- lmtest::coeftest(model, reg_vcov)
  model_df <- data.frame(model_coeftest[, 1:4])
  model_df <- data.frame(variable = rownames(model_df), model_df)
  model_df[["variable"]] <- as.character(model_df[["variable"]])
  rownames(model_df) <- NULL
  colnames(model_df) <- c("variable", "estimate", "std_error", "t-value", "p-value")

  # Return the data frame
  model_df
}
