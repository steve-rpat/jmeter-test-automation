#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <csv_file>"
    exit 1
fi

# Assign the first argument to a variable
csv_file=$1

# Check if the file exists
if [ ! -f "$csv_file" ]; then
    echo "File not found!"
    exit 1
fi

# Read the CSV file and check the "success" column for "false" values
# Assuming the first row is a header and "success" is a column name
# We will use awk to process the file
awk -F, '
BEGIN { 
    found_error = 0 
}

NR == 1 { 
    # Find the "success" column index
    for (i=1; i<=NF; i++) {
        if ($i == "success") {
            success_col = i
            break
        }
    }
    if (!success_col) {
        print "Error: No 'success' column found in the header."
        exit 1
    }
}

NR > 1 {
    # Check if the value in the "success" column is "false"
    if (tolower($success_col) == "false") {
        found_error = 1
    }
}

END { 
    if (found_error) {
        exit 1
    }
}' "$csv_file"

# Capture the exit code from awk and exit with the same code
echo Exit code = $?
exit $?
