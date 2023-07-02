
# opensciPackR

The `opensciPackR` is an R package that aims to promote the principles of open science by providing a streamlined approach to creating R packages specifically for research projects, e.g., for sharing data and code related to a published peer-reviewed paper. It is designed to ease the distribution, management, and analysis of structured research data.

The primary purpose of `opensciPackR` is to streamline the research reproduction process. By allowing researchers to install a package from GitHub that includes raw data, code for data preparation, analysis, and visualization, as well as comprehensive documentation, `opensciPackR` facilitates faster and more accurate research reproduction compared to downloading separate files and documentation from repositories such as OSF.

The key features of the package include:

1. **Templated Structure:** `opensciPackR` provides a templated structure for creating new R packages. This structure is designed in accordance with the current R package design principles introduced by [Hadley Wickham and Jennifer Bryan](https://r-pkgs.org/) and helps in organizing, documenting, and sharing research data and analysis.

2. **Customized R Package Creation:** The function `opensciPackR::create_openscipkg()` allows users to create a new open science R package with a standardized structure and setup. For example, it prompts the user to enter basic information about the package and the author, creates custom directories for data and their documentation, and generates core R scripts for data preparation and analysis. Note: The last feature is still under development.

3. **Data Uploading and Conversion:** The function `opensciPackR::upload_data()` allows users to upload datasets in various formats (csv, xlsx, xls, dat, sav, dta, RData, rda) and converts them to CSV format for archiving. It prompts the user to assign a new name to the dataset, adhering to good naming conventions. Additionally, it enables users to enter descriptions for their dataset and automatically generates the appropriate data documentation, which can be retrieved using the `help()` function.

4. **Interactive Sandboxes:**** `opensciPackR` integrates with the `learnr` package to create interactive sandboxes and tutorials for data exploration through `R Markdown` documents. These documents can be easily enhanced to include Shiny UI elements. This allows peer reviewers and other researchers to actively engage with the data and understand the analysis process step by step, as proposed by [Tso et al. (2022)](https://journal.r-project.org/articles/RJ-2022-021/). Note: This feature is still under development.

5. **Easy Hosting on GitHub:** The R packages created by `opensciPackR` can be hosted and installed through GitHub, which makes them easily accessible to other researchers. Researchers can fork the packages and build additional analysis plans or data comparisons on top of the existing work.

6. **Standardized Functions:** Every R package created by `opensciPackR` provides the same two primary functions, `prepare_data()` and `analyze_data()`. The `prepare_data()` function allows for quick reproduction of the data preparation process, including cleaning, transformation, and pre-processing. The `analyze_data()` function allows for quick reproduction of comprehensive data analysis, including summary statistics, statistical methods, and data visualization.


## Installation

You can install the most recent development version of `opensciPackR` from [GitHub](https://github.com/LKobilke/opensciPackR) with:

``` r
# install.packages("devtools")
devtools::install_github("LKobilke/opensciPackR")
```

Please note that `opensciPackR` is currently under development.

## Example
Here's a basic example that demonstrates the main function of `opensciPackR`:

``` r
library(opensciPackR)

# Create a new opensciPackR project
create_openscipkg("MyResearchPackage")
```


## Next Steps After Package Creation

After using the `opensciPackR::create_openscipkg()` function to create your package, there are several steps you should take to fully develop, document, and distribute it. Tip: Refer to [this book](https://r-pkgs.org/) by Hadley Wickham and Jennifer Bryan on R package development as your primary reference whenever you encounter uncertainties. They cover every aspect of setting up an R package, including [writing proper documentation](https://r-pkgs.org/man.html) and [running unit tests](https://r-pkgs.org/testing-basics.html). Also, check out these handy cheat sheets for R package development in [English (No. 1)](https://rklopotek.blog.uksw.edu.pl/files/2017/09/package-development.pdf), [English (No. 2)](https://raw.githubusercontent.com/rstudio/cheatsheets/main/package-development.pdf), and [German](https://raw.githubusercontent.com/rstudio/cheatsheets/main/translations/german/package-development_de.pdf).

Here is a step-by-step guide for what to do next:

1. **Navigate to the Package Directory:** Your new package has its own directory. Navigate to it using your file explorer and familiarize yourself with the structure. You'll find the R project file, named after your package, in the main directory. Additionally, you'll find raw data in the `/data-raw` subdirectory, processed data in the `/data` subdirectory, and the current data documentation in the `/R` subdirectory within the `/R/data.R` file. Since the `/R` subdirectory is where all the functions of your new package are stored, the two primary functions `prepare_data()` and `analyze_data()` are already saved there and can be customized from here.

2. **Open the R Project File:** If it didn't open automatically during the creation of your new package, open the project file in RStudio or a similar program.

3. **Update Data Documentation:** Navigate to `/R/data.R` and open `data.R`. Refine the data documentation that has been automatically generated by `opensciPackR`, e.g., by providing scales for the variables included in the dataset.

4. **Customize Functions:** Customize the `prepare_data()` and `analyze_data()` functions in the `/R` directory according to your needs and preferences. Learn how to write and organize functions with [the tidyverse style guide](https://style.tidyverse.org/index.html) and by referring to [programming with dplyr](https://dplyr.tidyverse.org/articles/programming.html). This is an iterative process of editing your functions and loading your entire package with the `devtools::load_all()` function (Shortcut: Ctrl/Cmd + Shift + L) to test whether your functions work as expected.

5. **Add More Scripts to `/R` Directory:** If necessary, add new R scripts that contain additional functions for your package. Use `roxygen2` comments (#') to [document your functions](https://r-pkgs.org/man.html#roxygen2-basics).

6. **Add Tests:** Integrate tests to ensure that your package functions are working correctly. You can learn about [using testthat for this purpose](https://r-pkgs.org/testing-basics.html). Store your tests in the `/tests` directory.

7. **Document the Package:** Use the `devtools::document()` function (Shortcut: Ctrl/Cmd + Shift + D) to process your `roxygen2` comments and automatically generate the `/man` files, which store the documentation.

8. **Check and Build the Package:** Use the `devtools::check()` function (Shortcut: Ctrl/Cmd + Shift + E) to ensure your package passes all CRAN checks. This is a good practice to follow, even if you are not submitting to CRAN.

9. **Host on GitHub:** Push your package to a GitHub repository. This makes it easily accessible to other researchers. Update the `README.md` file in your repository to document how to install and use your new package.

10. **Maintain and Update:** Keep your package up-to-date by fixing bugs, improving functionality, and responding to user feedback.


## Licence
This project is licensed under the MIT License.
