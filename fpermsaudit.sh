# Script for auditing file permission levels within the current directory and any lower directories. Output is saved in the current working directory.

audit_date_time=$(date +"%b-%d-%H:%M:%S")
echo "File permissions report completed "$audit_date_time" by "$(whoami)"." > fpermsaudit_"$audit_date_time".txt
echo "" >> fpermsaudit_"$audit_date_time".txt
echo "" >> fpermsaudit_"$audit_date_time".txt

# Fully Open Files (777)
echo "=================================================" >> fpermsaudit_"$audit_date_time".txt
echo "Fully Open Files (777)" >> fpermsaudit_"$audit_date_time".txt
echo "=================================================" >> fpermsaudit_"$audit_date_time".txt
echo "Permissions | Owner    | Group    | Size   | Path" >> fpermsaudit_"$audit_date_time".txt
echo "=================================================" >> fpermsaudit_"$audit_date_time".txt
find -type f -perm 777 -ls | awk '{
  printf "%-12s | %-8s | %-8s | %-6s | %s\n", $3, $5, $6, $7, $NF
}' >> fpermsaudit_"$audit_date_time".txt
fully_open_files_count=$(find -type f -perm 777 -ls | wc -l)
echo "Total: $fully_open_files_count files found" >> fpermsaudit_"$audit_date_time".txt
echo ""  >> fpermsaudit_"$audit_date_time".txt

# World-Readable and Executable Files (755)
echo "=================================================" >> fpermsaudit_"$audit_date_time".txt
echo "World-Readable and Executable Files (755)" >> fpermsaudit_"$audit_date_time".txt
echo "=================================================" >> fpermsaudit_"$audit_date_time".txt
echo "Permissions | Owner    | Group    | Size   | Path" >> fpermsaudit_"$audit_date_time".txt
echo "=================================================" >> fpermsaudit_"$audit_date_time".txt
find -type f -perm 755 -ls | awk '{
  printf "%-12s | %-8s | %-8s | %-6s | %s\n", $3, $5, $6, $7, $NF
}' >> fpermsaudit_"$audit_date_time".txt
world_rx_files_count=$(find -type f -perm 755 -ls | wc -l)
echo "Total: $world_rx_files_count files found" >> fpermsaudit_"$audit_date_time".txt
echo "" >> fpermsaudit_"$audit_date_time".txt

# SUID/SGID Files
echo "=================================================" >> fpermsaudit_"$audit_date_time".txt
echo "SUID/SGID Files (4xx, 6xx)" >> fpermsaudit_"$audit_date_time".txt
echo "=================================================" >> fpermsaudit_"$audit_date_time".txt
echo "Permissions | Owner    | Group    | Size   | Path" >> fpermsaudit_"$audit_date_time".txt
echo "=================================================" >> fpermsaudit_"$audit_date_time".txt
find -type f \( -perm -400 -o -perm -600 \) -ls | awk '{
  printf "%-12s | %-8s | %-8s | %-6s | %s\n", $3, $5, $6, $7, $NF
}' >> fpermsaudit_"$audit_date_time".txt
suid_sgid_files_count=$(find -type f \( -perm -400 -o -perm -600 \) -ls | wc -l)
echo "Total: $suid_sgid_files_count files found" >> fpermsaudit_"$audit_date_time".txt
echo "" >> fpermsaudit_"$audit_date_time".txt

# Specific SUID/SGID Bits (4000, 2000)
echo "=================================================" >> fpermsaudit_"$audit_date_time".txt
echo "Specific SUID/SGID Bits (4000, 2000)" >> fpermsaudit_"$audit_date_time".txt
echo "=================================================" >> fpermsaudit_"$audit_date_time".txt
echo "Permissions | Owner    | Group    | Size   | Path" >> fpermsaudit_"$audit_date_time".txt
echo "=================================================" >> fpermsaudit_"$audit_date_time".txt
find -type f \( -perm 4000 -o -perm 2000 \) -ls | awk '{
  printf "%-12s | %-8s | %-8s | %-6s | %s\n", $3, $5, $6, $7, $NF
}' >> fpermsaudit_"$audit_date_time".txt
specific_suid_sgid_files_count=$(find -type f \( -perm 4000 -o -perm 2000 \) -ls | wc -l)
echo "Total: $specific_suid_sgid_files_count files found" >> fpermsaudit_"$audit_date_time".txt
echo "" >> fpermsaudit_"$audit_date_time".txt
