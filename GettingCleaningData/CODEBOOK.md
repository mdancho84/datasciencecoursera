# Variables and Script Logic
-----
The script `run_analysis.R` performs the 5 steps described in the course project's definition. The logic is as follows:

* First, labels are read and formatted for the activity (variable trying to predict). These are used later with the Y outcome field, which maps the activity number with the label.
* Second, features are extracted and formatted. A subset of only the labels containing "mean()"" and "std()" were computed. These relate to the columns of interest in the `x_train` and `x_test` data sets.
* Third and forth, the training data and test data was read, formatted and combined. The subset of features including only the mean() and std() was used to subset `x_train` and `x_test`.
* Fifth, the training and test datasets were merged into the data frame `all_data`.
* Last, `tidy_data` was computed, which includes the average of each feature summarized by activity and subject. The tidy data is exported to the file `average_by_activity_subject.txt`.

# Code Used
-----
* `readr` package - Used to read the data (`read_delim()`, `read_csv()`, `write_csv()`') as data frames.
* `dplyr` and `tidyr` packages - Used to manipulate the data frames. `rename()` is used to rename columns as needed. `group_by()` and `summarize_each()` were used to compute the average for each variable in the tidy dataset.
* `grep()` from base package and `stringr` package - Regular Expressions were used to find "mean()" and "std()" within features. `str_replace_all()` was used to format text.
* Other base `R` functions - Various other base `R` functions were used to combine and merge data, which include `rbind()`, `cbind()` and `merge()`.
*