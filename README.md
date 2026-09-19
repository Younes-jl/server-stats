 # Server Stats
https://github.com/Younes-jl/server-stats.git
## Objective

This script is designed to collect and display essential server performance and health statistics in one place. It helps administrators quickly monitor the current state of a server and identify potential resource or availability issues.

Depending on the server environment, the statistics may include:

- CPU usage
- Memory usage
- Disk space and usage
- System uptime
- Running processes
- Network activity
- Alerts for detected resource or availability issues

The goal is to provide a simple overview that supports routine monitoring, troubleshooting, and capacity planning.
The script also handles alert conditions so administrators can be notified when monitored thresholds or availability checks indicate a potential issue.

## Usage

Run the script from the command line in the environment where the server statistics should be collected. Review the output to assess resource consumption and server health.
==> ./server_stats.sh

## Requirements

Ensure that the runtime and permissions required by the script are available on the target server.
==>  chmod +x server_stats.sh
