# Pipewire

[PipeWire](https://pipewire.org) is a server and user space API to
deal with multimedia pipelines. This includes:

  - Making available sources of video (such as from a capture devices or
    application provided streams) and multiplexing this with
    clients.
  - Accessing sources of video for consumption.
  - Generating graphs for audio and video processing.

Nodes in the graph can be implemented as separate processes,
communicating with sockets and exchanging multimedia content using fd
passing.

## Install in linux

Gstrimer pipewire library

``` gstrimer pipewire
sudo apt install gstreamer1.0-pipewire
```

Pipewire library

``` libpipewire
sudo apt install libpipewire-0.3-{0,dev,modules}
```

SPA

``` spa
sudo apt install libspa-0.2-{bluetooth,dev,jack,modules}
```
