
# opensciPackR

The goal of opensciPackR is to facilitate open science by providing a templated R package for structured research data distribution, management, and analysis. This package allows researchers to package their data and analysis code, ensuring reproducibility, transparency, and accessibility of research findings. By using opensciPackR, researchers can easily create custom R packages for their research projects, share them on GitHub, and collaborate with other researchers.

## Installation

You can install the development version of opensciPackR from [GitHub](https://github.com/LKobilke/opensciPackR) with:

``` r
# install.packages("devtools")
devtools::install_github("https://github.com/LKobilke/opensciPackR")
```

Please note that opensciPackR is currently under development, so the above installation installs the development version from GitHub.

## Example
Here's a basic example that demonstrates the main function of opensciPackR:

``` r
library(opensciPackR)

# Create a new opensciPackR project
create_openscipkg("MyResearchPackage")
```

## Licence
This project is licensed under the MIT License.
