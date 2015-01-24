The run_analysis.r creats a tidy dataset from a raw data collected from Samsung Galaxy S smarthpone about activities of 30 subjects while performing activites of daily living. See http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones for further information about the data.

Note that you require the data.table package to run the script. I use the data.table package to lookup activity descriptions by the activity number, from the activity_labels.txt in the dataset.

The script downloads the data into your working directory and unzips it. It then reads in the training and test data, joins them together by binding their rows together. Then add labels to the dataset that explain what activity each row has data on, and add column names that explain what the column measurements are.
I then extract all mean and standard deviation columns, columns that have the words mean, or std in them, but not meanFreq, and take column averages by activity, and write that data to a text file.

I gained valuable insights on how to proceed with this task from David Hood, community TA, on the class discussion forum, see David's Project FAQ discussion, https://class.coursera.org/getdata-010/forum/thread?thread_id=49.

The CodeBook.md describes the variables, the data, and any transformations or work performed to clean up the data.

This work was performed as a part of a project in the Getting and cleaning data online course from Johns Hopkins. See https://class.coursera.org/getdata-010 for further information.

