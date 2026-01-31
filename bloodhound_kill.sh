#!/bin/bash
# bloodhound_stop.sh - Script to gracefully stop Bloodhound

echo "Stopping Bloodhound and Neo4j..."

# Terminate Bloodhound process (excluding this script itself)
echo "[1/3] Stopping Bloodhound GUI..."
pkill -f "BloodHound" 2>/dev/null || echo "Bloodhound process not found"
sleep 1

 Gracefully stop Neo4j
echo "[2/3] Stopping Neo4j database..."
sudo neo4j stop 2>/dev/null || echo "Neo4j not running or already stopped"
sleep 2

# Force kill Neo4j process if still running
if pgrep -f "neo4j" > /dev/null; then
    echo "Neo4j still running, force stopping..."
    sudo pkill -9 -f "java.*neo4j"
    sleep 2
fi

# Check and terminate processes using ports 7474 and 7687
echo "[3/3] Checking for processes on Neo4j ports..."
sudo lsof -ti:7474 2>/dev/null | xargs -r sudo kill -9 2>/dev/null
sudo lsof -ti:7687 2>/dev/null | xargs -r sudo kill -9 2>/dev/null

echo ""
echo "✓ Done! Bloodhound and Neo4j stopped."
echo ""
echo "Verification:"
pgrep -a "BloodHound|neo4j" || echo "No Bloodhound or Neo4j processes running"
