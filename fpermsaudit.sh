#!/bin/bash
# Script for auditing file permission levels within the current directory and subdirectories. Output is saved in the current working directory.

audit_date_time=$(date +"%b-%d-%H:%M:%S")
audit_output_file="fpermsaudit_${audit_date_time}.txt"

# Checks if the output file can be created
if ! echo "File permissions report completed $audit_date_time by $(whoami)." > "$audit_output_file"; then
    echo "Error: Failed to create the audit file."
    exit 1
fi

# Checks if user has sudo privileges and appropriate directory access
if ! sudo -v &>/dev/null && [[ -z $(find . -type f -print -quit 2>/dev/null) ]]; then
    echo "Warning: Report may contain limited results from the current directory. Consider running with sudo for a more complete audit."
fi

# Helper function to format and output audit sections
output_section() {
    local title=$1
    local results="$2"
    local count=$3

    {
        echo "================================================="
        echo "$title"
        echo "================================================="
        echo "Permissions | Owner    | Group    | Size   | Path"
        echo "================================================="
        echo "$results" | awk '{printf "%-12s | %-8s | %-8s | %-6s | %s\n", $3, $5, $6, $7, $NF}'
        echo ""
        echo "Total: $count files found"
        echo ""
    } >> "$audit_output_file"
}

# Collect results and counts for each permission category
fully_open_results=$(find . -type f -perm 0777 -ls)
fully_open_count=$(echo "$fully_open_results" | grep -v '^$' | wc -l)

world_rx_results=$(find . -type f -perm 0755 -ls)
world_rx_count=$(echo "$world_rx_results" | grep -v '^$' | wc -l)

suid_sgid_results=$(find . -type f \( -perm -4000 -o -perm -2000 \) -ls)
suid_sgid_count=$(echo "$suid_sgid_results" | grep -v '^$' | wc -l)

# Write report header
{
    echo "File permissions report completed $audit_date_time by $(whoami)."
    echo ""
} >> "$audit_output_file"

# Output each section
output_section "Fully Open Files (777)" "$fully_open_results" "$fully_open_count"
output_section "World-Readable and Executable Files (755)" "$world_rx_results" "$world_rx_count"
output_section "SUID/SGID Files (4000, 2000)" "$suid_sgid_results" "$suid_sgid_count"

# Completion message
echo "Results have been outputted to \"$audit_output_file\"."
