#!/bin/bash

# Include trybatch.sh as a library
source /home/ubuntu/mediaCenter/trycatch.sh
# sourcing it in supervisor command

# Define custom exception types
export ERR_BAD=100
export ERR_WORSE=101
export ERR_CRITICAL=102

try
(
    # When a command returns a non-zero, a custom exception is raised.
    echo "Mounting: Real Debrid"
    cd /home/ubuntu/mediaCenter
    ./rclone-linux mount realdebrid: torrents --dir-cache-time 10s --allow-other --allow-non-empty || throw $ERR_BAD
    # This statement is not reached if there is any exception raised
    # inside the try block.
    echo "Mounted: Real Debrid"
)

catch || {
    case $exception_code in
        $ERR_BAD)
            echo "Unmounting: torrents folder"
            cd /home/ubuntu/mediaCenter
            fusermount -uz torrents || sudo umount -l torrents
            echo "Unmounted: torrents folder"
        ;;
        $ERR_WORSE)
            echo "Unmounting: This error is worse"
        ;;
        $ERR_CRITICAL)
            echo "Unmounting: This error is critical"
        ;;
        *)
            echo "Unmounting Unknown error: $exit_code"
            throw $exit_code    # re-throw an unhandled exception
        ;;
    esac
}