#!/usr/bin/env python3

import os
import sys
import tarfile
from datetime import datetime

Archive_Dir = "/var/log/archives"
Log_File = "/var/log/archive_log.txt"

def compress_logs(log_directory, archive_directory):
    # Create archive directory if it doesn't exist
    if not os.path.exists(archive_directory):
        os.makedirs(archive_directory)

    # Create a timestamped archive name
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    archive_name = f"logs_archive_{timestamp}.tar.gz"
    archive_path = os.path.join(archive_directory, archive_name)

    with tarfile.open(archive_path, "w:gz") as tar:
        tar.add(log_directory, arcname=os.path.basename(log_directory))

    with open(Log_File, "a") as log:
        log.write(f"{datetime.now()}: Archived logs from {log_directory} to {archive_path}\n")

    print(f"Logs archived successfully to {archive_path}")
    upload_to_s3(archive_path, "my-log-archives-bucket")

def upload_to_s3(archive_path, bucket_name):
    try:
        command = f"aws s3 cp {archive_path} s3://{bucket_name}/"
        subprocess.run(command, shell=True, check=True)
        print(f"Successfully uploaded {archive_path} to s3://{bucket_name}/")
    except subprocess.CalledProcessError as e:
        print(f"Failed to upload to S3: {e}")

def main():
    # Check if the correct number of arguments are provided
    if len(sys.argv) != 2:
        print("Usage: log-archive <log-directory>")
        sys.exit(1)

    log_directory = sys.argv[1]

    if not os.path.exists(log_directory):
        print(f"Error: Log directory {log_directory} does not exist.")
        sys.exit(1)

    compress_logs(log_directory, Archive_Dir)

if __name__ == "__main__":
    main()
