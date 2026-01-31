# Bloodhound Stop Script

A script to gracefully stop Bloodhound and Neo4j database running on Kali Linux.

## Overview

This script executes the following processes in order:
1. Terminate Bloodhound GUI process
2. Gracefully stop Neo4j database
3. Force kill remaining processes
4. Clean up used ports (7474, 7687)

## Requirements

- Kali Linux (or other Debian-based Linux)
- Bloodhound
- Neo4j
- sudo privileges

## Installation

```bash
# Download or create the script
nano bloodhound_stop.sh

# Grant execute permission
chmod +x bloodhound_stop.sh
```

## Usage

### Basic Usage

```bash
./bloodhound_stop.sh
```

**Note:** You may be prompted for a password as stopping Neo4j requires sudo privileges.

### Running with sudo

```bash
sudo ./bloodhound_stop.sh
```

## Script Output

```
Stopping Bloodhound and Neo4j...
[1/3] Stopping Bloodhound GUI...
[2/3] Stopping Neo4j database...
[3/3] Checking for processes on Neo4j ports...

✓ Done! Bloodhound and Neo4j stopped.

Verification:
No Bloodhound or Neo4j processes running
```

## Step-by-Step Explanation

### Step 1: Terminate Bloodhound GUI
```bash
pkill -f "BloodHound"
```
- Terminates the Bloodhound graphical interface
- Displays a message if the process is not found

### Step 2: Gracefully Stop Neo4j
```bash
sudo neo4j stop
```
- Gracefully stops the Neo4j database service
- Ensures data integrity during shutdown

### Step 3: Force Kill Remaining Processes
```bash
sudo pkill -9 -f "java.*neo4j"
```
- Force kills Neo4j processes if they didn't stop gracefully
- Targets Neo4j running as Java processes

### Step 4: Port Cleanup
```bash
sudo lsof -ti:7474 | xargs -r sudo kill -9
sudo lsof -ti:7687 | xargs -r sudo kill -9
```
- Releases ports 7474 (HTTP) and 7687 (Bolt) used by Neo4j
- Prevents port conflicts on next startup

## Troubleshooting

### If Processes Won't Terminate

Manual verification and termination methods:

```bash
# Check processes
ps aux | grep -E "BloodHound|neo4j"

# Manually terminate
killall -9 BloodHound
sudo neo4j stop
sudo pkill -9 -f "java.*neo4j"
```

### If Ports Won't Release

```bash
# Check port usage
sudo netstat -tulpn | grep -E "7474|7687"

# Or
sudo lsof -i :7474
sudo lsof -i :7687

# Force release ports
sudo fuser -k 7474/tcp
sudo fuser -k 7687/tcp
```

### "Permission denied" Error

```bash
# Run with sudo
sudo ./bloodhound_stop.sh

# Or use sudo only for specific commands
# (The script is already configured this way)
```

## Verification

After running the script, verify proper shutdown with these commands:

```bash
# Check processes
pgrep -a BloodHound
pgrep -a neo4j

# Check ports
sudo netstat -tulpn | grep -E "7474|7687"

# If nothing is displayed, the shutdown was successful
```

## Restarting Bloodhound

To restart Bloodhound after stopping with this script:

```bash
# Start Neo4j
sudo neo4j start

# Or
sudo neo4j console  # Start in foreground

# Start Bloodhound
bloodhound
```

## License

This script is freeware. Feel free to use and modify it.

## Notes

- This script may force-terminate Bloodhound and Neo4j
- Save important data analysis before running
- The script attempts graceful shutdown first to maintain Neo4j database integrity

## Related Links

- [Bloodhound GitHub](https://github.com/BloodHoundAD/BloodHound)
- [Neo4j Documentation](https://neo4j.com/docs/)
- [Kali Linux](https://www.kali.org/)
