#!/bin/bash

# Define the log file path
LOG_FILE="/var/log/nginx/access.log"  # Adjust this path as needed

# Top 5 IP addresses with the most requests
function top_ip_addresses {
    echo "Top 5 IP addresses with the most requests:"
    awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests"}'
    echo
}

# Top 5 most requested paths
function top_requested_paths {
    echo "Top 5 most requested paths:"
    awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests"}'
    echo
}

# Top 5 response status codes
function top_response_status_codes {
    echo "Top 5 response status codes:"
    awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests"}'
    echo
}

# Top 5 user agents
function top_user_agents {
    echo "Top 5 user agents:"
    awk -F'"' '{print $6}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests"}'
    echo
}

# Run the functions
top_ip_addresses
top_requested_paths
top_response_status_codes
top_user_agents
