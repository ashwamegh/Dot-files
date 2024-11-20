# zurg Configuration Documentation

This document details all available configuration options for zurg. Configure these options in your `config.yaml` file.

## Basic Configuration

```yaml
# Zurg configuration version (default: "v1")
zurg: v1

# Your Real-Debrid API token (required)
token: YOUR_RD_API_TOKEN

# Additional RD API tokens for when daily bandwidth limit is reached
download_tokens:
  - ANOTHER_RD_API_TOKEN
  - ANOTHER_RD_API_TOKEN_2
```

## Core Settings

### Network & Server Configuration

```yaml
# Host address to bind to (default: "[::]")
host: "[::]"

# Port to listen on (default: "9999")
port: 9999

# HTTP proxy configuration (optional)
proxy: "http://[username:password@]host:port"
# Also supports HTTPS and SOCKS5:
# proxy: "https://[username:password@]host:port"
# proxy: "socks5://[username:password@]host:port"

# Force IPv6 usage for all network tests
force_ipv6: false

# Limit the number of hosts to N fastest hosts
number_of_hosts: 3

# IP to use for unrestricting links
unrestrict_ip: ""
```

### Authentication

```yaml
# Basic authentication credentials (optional)
username: ""
password: ""
```

### Performance & Rate Limits

```yaml
# Rate limit for the API except /torrents call (default: 250)
api_rate_limit_per_minute: 250

# Rate limit for the /torrents call for fetching torrents (default: 75)
torrents_rate_limit_per_minute: 75

# API timeout settings
api_timeout_secs: 60      # timeout for all API calls (default: 60)
download_timeout_secs: 15  # timeout for all download calls (default: 15)

# Number of retries before marking a request as failed (default: 2)
retries_until_failed: 2

# Retry 503 errors specifically
retry_503_errors: false

# How many torrents are fetched per page of /torrents call (default: 250)
fetch_torrents_page_size: 250
```

### File Management

```yaml
# Enable automatic torrent repair
enable_repair: true

# Action for RAR files: extract, delete, or none (default: "none")
rar_action: none

# Additional file extensions to consider as playable
addl_playable_extensions:
  - m3u
  - jpg

# If a torrent contains any file with these extensions, delete the torrent
delete_torrent_if_extensions_found:
  - zipx
  - rar

# Even when files are not selected in the torrent, if the file is playable (video or addl_playable_extensions), it will be selected
force_select_playable_files: false

# Retain the torrent name extension which is used for directory names (useful for single file torrents)
retain_folder_name_extension: false

# Retain the name value of a torrent from real-debrid (if false, will use original_name instead)
retain_rd_torrent_name: false

# Delete torrents that have encountered an error
delete_error_torrents: false

# Hide torrents that are broken (unplayable)
hide_broken_torrents: false

# Will ignore rename values in the torrent
ignore_renames: false
```

### Scheduling & Updates

```yaml
# How often to check for changes in the library (default: 15 seconds)
check_for_changes_every_secs: 15

# How often to check for broken torrents and repair them (default: 60 minutes)
repair_every_mins: 60

# How often to check for new downloads (unrestricted links, file locker links) (default: 720 minutes)
downloads_every_mins: 720

# How often to dump your library torrents to the dump folder for backup (default: 1440 minutes)
dump_torrents_every_mins: 1440

# Command to run when the library is updated (useful for plex refresh)
on_library_update: "sh plex_update.sh \"$@\""
```

### Media Analysis

```yaml
# Will run ffprobe on newly added torrents to your library
auto_analyze_new_torrents: true

# Cache the results of network tests so that it doesn't have to be run every startup
cache_network_test_results: true
```

### Advanced Features

```yaml
# Will log download request stats
log_requests: false

# Will download and serve files from rclone instead of zurg (webdav)
serve_from_rclone: false

# Load torrents from the dump folder on startup
load_dumped_torrents: false

# Load torrents from the trash folder on startup
load_trashed_torrents: false
```

## Example Configuration

Here's a basic example configuration with commonly used options:

```yaml
zurg: v1
token: YOUR_RD_API_TOKEN
enable_repair: true
rar_action: extract
auto_analyze_new_torrents: true
cache_network_test_results: true
addl_playable_extensions:
  - m3u
  - jpg
on_library_update: sh plex_update.sh "$@"
```

## Notes

- All time-based configurations are in their respective units (seconds or minutes) as specified in the option names
- Rate limits help prevent API throttling from Real-Debrid
- The `enable_repair` option must be true for `rar_action: extract` to work
- Be cautious with `delete_error_torrents` as it permanently removes problematic torrents
- `cache_network_test_results` helps reduce startup time by saving previous network test results
- When `retain_rd_torrent_name` is false, for example with a season pack, if only 1 file is selected, the torrent name will be the name of the file not the season pack
