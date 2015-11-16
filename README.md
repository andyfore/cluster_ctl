# cluster_ctl.sh
A utility script designed to control the status of a node heartbeat in a cluster

**Script name** cluster_ctl.sh

*Created* 2015-11-16

*Original Author* Andrew Fore [andy.fore@arfore.com](mailto:andy.fore@arfore.com)

**File List**

* cluster_ctl.sh - this is the main script file

**Usage**

Currently the script takes one of three commandline options:

-c outputs the number of processes for the configured service, lists the configured listeners for the ports, and the node status based on the configured heartbeat file

-d disables the service configuration for the load balancer by moving the current heartbeat file to an unexpected name

-e enables the service configuration for the load balancer by moving the heartbeat file back to the expected name

```bash
# cluster_ctl.sh -cde
```
