Introduction to regr
================

The goal of this package is to provide users the ability to easily replicate STATA regressions in R. Particularly, this package provides the `reg` function, inspired by STATA's `reg` command. This function allows users to quickly run regressions with robust or clustered standard errors and returns results which match those of STATA. This document demonstrates how to use `regr`.

Data
----

This example uses test data from Petersen (2006). Petersen performs the following analyses on this data:

1.  Standard OLS (`reg y x`)
2.  Robust standard errors: (`reg y x, robust`)
3.  Cluster standard errors by firm (`reg y x, cluster(firmid)`)
4.  Cluster standard errors by year (`reg y x, cluster(year)`)
5.  Cluster standard errors by firm and year (`reg y x, cluster(firmid, year)`)

Petersen provides the results to these analyses using STATA [here](http://www.kellogg.northwestern.edu/faculty/petersen/htm/papers/se/test_data.htm). We will replicate these analyses in turn to demonstrate the use of `regr`.

Example Regressions
-------------------

First, we load the data.

``` r
library(regr)
data("panel_data")
```

Now, we can run the regressions.

### 1. Basic OLS

``` r
reg(y ~ x, panel_data)
```

    ##      variable   estimate  std_error  t-value       p-value
    ## 1 (Intercept) 0.02967972 0.02835932  1.04656  2.953533e-01
    ## 2           x 1.03483344 0.02858329 36.20414 4.252163e-255

### 2. Robust standard errors

``` r
reg(y ~ x, panel_data, robust = TRUE)
```

    ##      variable   estimate  std_error  t-value       p-value
    ## 1 (Intercept) 0.02967972 0.02836067  1.04651  2.953763e-01
    ## 2           x 1.03483344 0.02839516 36.44401 4.292634e-258

### 3. Cluster standard errors by firm

``` r
reg(y ~ x, panel_data, cluster = "firmid")
```

    ##      variable   estimate  std_error    t-value      p-value
    ## 1 (Intercept) 0.02967972 0.06701270  0.4428969 6.578595e-01
    ## 2           x 1.03483344 0.05059573 20.4529814 2.352034e-89

### 4. Cluster standard errors by year

``` r
reg(y ~ x, panel_data, cluster = "year")
```

    ##      variable   estimate  std_error   t-value       p-value
    ## 1 (Intercept) 0.02967972 0.02338672  1.269084  2.044701e-01
    ## 2           x 1.03483344 0.03338891 30.993325 4.542406e-193

### 5. Cluster standard errors by both firm and year

``` r
reg(y ~ x, panel_data, cluster = c("firmid", "year"))
```

    ##      variable   estimate  std_error    t-value      p-value
    ## 1 (Intercept) 0.02967972 0.06506392  0.4561625 6.482929e-01
    ## 2           x 1.03483344 0.05355802 19.3217259 2.804600e-80
