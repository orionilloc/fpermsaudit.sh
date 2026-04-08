## File Permissions Auditor

This script performs a security audit of file permissions within the current directory and all subdirectories. It identifies files with potentially risky permission levels—such as those that are world-writable or have SUID/SGID bits set—and generates a formatted text report.

---

### Features

* **Recursive Auditing:** Scans the current working directory and all nested folders.
* **Targeted Detection:** Specifically flags three critical permission categories:
    * **Fully Open (777):** Files that anyone can read, write, and execute.
    * **World-Readable/Executable (755):** Standard for binaries but worth monitoring for sensitive data.
    * **SUID/SGID:** Files that execute with the permissions of the owner or group (potential privilege escalation vectors).
* **Formatted Output:** Generates a clean, tabular report including permissions, owner, group, file size, and path.
* **Timestamped Logs:** Each run creates a unique file (e.g., `fpermsaudit_Apr-08-15:40:12.txt`) to prevent overwriting previous audits.

---

### Prerequisites

* **Environment:** Linux/Unix-based system with `bash`.
* **Dependencies:** Standard core utilities (`find`, `awk`, `grep`, `wc`).
* **Privileges:** While it can run as a standard user, running with `sudo` is recommended to ensure the script can audit directories restricted by system permissions.

---

### Usage

1.  **Make the script executable:**
    ```bash
    chmod +x audit_permissions.sh
    ```

2.  **Run the script:**
    ```bash
    ./audit_permissions.sh
    ```

3.  **Run with sudo (recommended for full coverage):**
    ```bash
    sudo ./audit_permissions.sh
    ```

---

### Report Details

The generated report includes a summary header and three distinct sections. Each section provides a total count of the files found.

| Column | Description |
| :--- | :--- |
| **Permissions** | The symbolic notation (e.g., `-rwxrwxrwx`). |
| **Owner** | The username of the file creator/owner. |
| **Group** | The group assigned to the file. |
| **Size** | The size of the file. |
| **Path** | The relative path to the file from the audit root. |

---

> [!WARNING]
> This script is an auditing tool. It does not automatically modify any file permissions. Any remediation should be performed manually based on the generated report.
