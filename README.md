# Max MTU finder

Little bash script to help find the maximum MTU between a source and destination.

For when PMTU is inevitably broken.

Works with BSD or GNU `ping`.

I know tracepath and other tools exist. This was just hacked together in a tight spot with no internet access.

# Usage

```
Usage: pmtu_finder.sh target_ip {min_mtu (1200)} {max_mtu (1514)} {die_after(3)}
```

# Example

```
$ ./pmtu_finder.sh 10.0.0.7 1300
10.0.0.7 1300 1514
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!...Stopping.
No response after 1352 (1380 with headers)
```
