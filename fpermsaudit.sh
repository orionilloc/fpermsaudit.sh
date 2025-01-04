#!/bin/bash
# Script for auditing file permission levels within the current directory and any lower directories. Output is saved in the current working directory.

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

# Creates and formats the audit file
echo "File permissions report completed $audit_date_time by $(whoami)." > "$audit_output_file"
echo "" >> "$audit_output_file"
echo "" >> "$audit_output_file"

# Collect results and counts for each permission category
fully_open_results=$(find . -type f -perm 777 -ls)
fully_open_file_count=$(echo "$fully_open_results" | grep -v '^$' | wc -l)  # Exclude empty lines and count non-empty ones

world_rx_results=$(find . -type f -perm 755 -ls)
world_rx_file_count=$(echo "$world_rx_results" | grep -v '^$' | wc -l)  # Exclude empty lines and count non-empty ones

suid_sgid_results=$(find . -type f \( -perm -400 -o -perm -600 \) -ls)
suid_sgid_file_count=$(echo "$suid_sgid_results" | grep -v '^$' | wc -l)  # Exclude empty lines and count non-empty ones

specific_suid_sgid_results=$(find . -type f \( -perm 4000 -o -perm 2000 \) -ls)
specific_suid_sgid_file_count=$(echo "$specific_suid_sgid_results" | grep -v '^$' | wc -l)  # Exclude empty lines and count non-empty ones


# Fully Open Files (777)
echo "=================================================" >> "$audit_output_file"
echo "Fully Open Files (777)" >> "$audit_output_file"
echo "=================================================" >> "$audit_output_file"
echo "Permissions | Owner    | Group    | Size   | Path" >> "$audit_output_file"
echo "=================================================" >> "$audit_output_file"
echo "$fully_open_results" | awk '{printf "%-12s | %-8s | %-8s | %-6s | %s\n", $3, $5, $6, $7, $NF}' >> "$audit_output_file"
echo "" >> "$audit_output_file"
echo "Total: $fully_open_file_count files found" >> "$audit_output_file"
echo "" >> "$audit_output_file"

# World-Readable and Executable Files (755)
echo "=================================================" >> "$audit_output_file"
echo "World-Readable and Executable Files (755)" >> "$audit_output_file"
echo "=================================================" >> "$audit_output_file"
echo "Permissions | Owner    | Group    | Size   | Path" >> "$audit_output_file"
echo "=================================================" >> "$audit_output_file"
echo "$world_rx_results" | awk '{printf "%-12s | %-8s | %-8s | %-6s | %s\n", $3, $5, $6, $7, $NF}' >> "$audit_output_file"
echo "" >> "$audit_output_file"
echo "Total: $world_rx_file_count files found" >> "$audit_output_file"
echo "" >> "$audit_output_file"

# SUID/SGID Files (4xx, 6xx)
echo "=================================================" >> "$audit_output_file"
echo "SUID/SGID Files (4xx, 6xx)" >> "$audit_output_file"
echo "=================================================" >> "$audit_output_file"
echo "Permissions | Owner    | Group    | Size   | Path" >> "$audit_output_file"
echo "=================================================" >> "$audit_output_file"
echo "$suid_sgid_results" | awk '{printf "%-12s | %-8s | %-8s | %-6s | %s\n", $3, $5, $6, $7, $NF}' >> "$audit_output_file"
echo "" >> "$audit_output_file"
echo "Total: $suid_sgid_file_count files found" >> "$audit_output_file"
echo "" >> "$audit_output_file"

# Specific SUID/SGID Bits (4000, 2000)
echo "=================================================" >> "$audit_output_file"
echo "Specific SUID/SGID Bits (4000, 2000)" >> "$audit_output_file"
echo "=================================================" >> "$audit_output_file"
echo "Permissions | Owner    | Group    | Size   | Path" >> "$audit_output_file"
echo "=================================================" >> "$audit_output_file"
echo "$specific_suid_sgid_results" | awk '{printf "%-12s | %-8s | %-8s | %-6s | %s\n", $3, $5, $6, $7, $NF}' >> "$audit_output_file"
echo "" >> "$audit_output_file"
echo "Total: $specific_suid_sgid_file_count files found" >> "$audit_output_file"
echo "" >> "$audit_output_file"

# Reports that results have been dumped in the file listed here
echo "Results have been outputted to "$audit_output_file.""
