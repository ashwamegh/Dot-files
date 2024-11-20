#!/bin/bash

# PLEX PARTIAL SCAN script or PLEX UPDATE script (Docker)
# When zurg detects changes, it can trigger this script IF your config.yml contains
# on_library_update: sh plex_update.sh "$@"

# dockerip=$(/sbin/ip route|awk '/default/ { print $3 }') # if zurg is running inside a Docker container
localip="IP_ADDRESS" # if zurg is running on the host machine, and Plex is running on the same machine
external="plexdomain.com" # if Plex is running on a different machine

plexip=$localip # replace with your Plex IP

plex_url="http://$plexip:32400" # If you're using zurg inside a Docker container, by default it is 172.17.0.1:32400
echo "Detected Plex URL inside Docker container: $plex_url"
token="XXXXXXXXXXXXXXXXXXX" # open Plex in a browser, open dev console and copy-paste this: window.localStorage.getItem("myPlexAccessToken")
zurg_mount="/mnt/zurg" # replace with your zurg mount path, ensure this is what Plex sees

section_ids=$(curl -sLX GET "$plex_url/library/sections" -H "X-Plex-Token: $token" | xmllint --xpath "//Directory/@key" - | grep -o 'key="[^"]*"' | awk -F'"' '{print $2}')

if [ -z "$section_ids" ]; then
	echo "Error: missing sections; the token seems to be broken"
    exit 1
fi

echo "Plex section IDs: $section_ids"
sleep 1

for arg in "$@"
do
    modified_arg="$zurg_mount/$arg"
    echo "Updating in Plex: $modified_arg"

    encoded_arg=$(echo -n "$modified_arg" | python3 -c "import sys, urllib.parse as ul; print (ul.quote_plus(sys.stdin.read()))")

    if [ -z "$encoded_arg" ]; then
        echo "Error: encoded argument is empty, check the input or encoding process"
        continue
    fi

    for section_id in $section_ids
    do
        final_url="${plex_url}/library/sections/${section_id}/refresh?path=${encoded_arg}&X-Plex-Token=${token}"
        curl -s "$final_url"
        echo "Triggered scan with URL: $final_url"
    done
done

echo "All updated sections refreshed!"

# credits to godver3
