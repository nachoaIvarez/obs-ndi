# obs-ndi

Ubuntu-based Docker image with VNC and XFCE, includes OBS Studio with NDI support and NVIDIA hardware acceleration.

I use this for my dual (gaming and streaming) PC setup. My gaming PC sends the screen capture via NDI to my server running this image in a Docker container so all the OBS scenes, transcoding, and streaming happen over there, effectively offloading my gaming PC, so I can run my games at higher FPS and suck anyways.

## Features

- **Ubuntu with XFCE**
- **VNC Access**
- **OBS Studio with NDI**
- **NVIDIA Hardware Acceleration**

## Environment Variables

- `VNC_PASSWD`: Set the VNC password (default is `headless`)
- `NVIDIA_DRIVER_CAPABILITIES`: Allows all NVIDIA driver capabilities for the container by default\*
- `NVIDIA_VISIBLE_DEVICES`: Makes all NVIDIA devices available to the container
- `HOST_NAME`: Customize the container's host name (default is `obs`) so you can access it on the network by doing `obs.local[:5901,:4455]` instead of an ugly IP

_\* You can try with `NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"` if you want a more restrictive approach._

## Ports

- `6901`: For HTTP VNC web access\*
- `4455`: For OBS websocket server connections
- `5901`: For VNC connections

_\*I suggest you map it to 80 at docker run with `-p 80:6901` so you can just visit `obs.local` on your browser. See [run instructions](#running-the-container) below._

## Volumes

- `/config`: Stores OBS Studio configuration data persistently

## Getting Started

### Running the Container

To start a container:

```bash
docker run -d -p 80:6901 -p 5901:5901 -p 4455:4455 --env VNC_PASSWD=<your password> ghcr.io/nachoaivarez/obs-ndi
```

_Note: Replace `<your password>` with your desired VNC password. If you leave it empty it will default to `headless`_

### Accessing OBS Studio

1. **Via Browser**: Go to `http://obs.local`
1. **Via VNC**: Connect using `vnc://obs.local:5901`

## Credits and resources

- [Asparon](https://www.twitch.tv/asparon)'s work on [asparon/obs-ndi](https://github.com/asparon/obs-ndi) was the starting point of this image, I added several quality of life improvements.
- A good Unraid tutorial can be found [here](https://www.youtube.com/watch?v=uyEvE_yr5qs). With this image however you can skip multiple steps from the video (like the static IP part or sourcing and providing GPU ids) as well as being able to access it under the `.local` domain because of the mDNS setup.
