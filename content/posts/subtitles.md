---
title: "subtitles"
date: 2025-02-08T21:11:13-08:00
draft: false
---

### Problem

HDR is too good. Darks are too dark and brights are too bright. Subtitles are white, and therefore too bright in dark scenes. You can render them grey, but, then they're unnecessarily dark in bright scenes, and bright in dark scenes.


### Solution

I wrote a [script](https://github.com/graevy/greyer) that reads a video file concurrently with an SRT file. The SRT file contains time indicies of each rendered subtitle. I navigate to the `start_time` in ffmpeg, determine its *luminance*, and adjust the *color* of the SRT entry accordingly.


### I learned too much about video formats for this, now you have to, too

Pretty much all video you download is formatted in `yuv420p`. What is `yuv420p`, you ask? Color quantization. It's a lossy transcoding scheme for color. Eyes see brightness more clearly than color. Video may be *encoded* in `h264`, `hevc`, whatever, but the actual video being encoded is in the `yuv420p` format.

The Y in `yuv` stands for "Luminance". Don't ask me why. U and V are color values. We care about luminance. `yuv420p` groups pixels into 2x2 blocks, in which each of the 4 pixels gets a brightess byte, and each block of 4 pixels gets 1 U and 1 V color byte. Don't ask me why it isn't `yuv411`, which also exists. The `p` stands for "planar", by the way. In RGB, 4 pixels gets 12 bytes (3 per pixel); in YUV, 4 pixels gets 6.

We have to talk about encodings though. How do we encode video? Let's start with the raw. Let's say I film a 2 hour movie in 1080p, 60fps, without any encoding or compression. 1920 times 1080 is about 2 million pixels per frame. 2 hours is 7200 seconds is 432000 frames. 432000 * 2 million is 864 billion pixels. What's in a pixel? Let's say it's just RGB. That's 3 bytes per pixel, so we're sitting north of 2 terabytes. When you download a movie, we can get watchable quality under a gigabyte. How?

Well, firstly, most pixels in video don't change every frame! We only need to record pixels that change. If part of the scene is just black for 2 seconds, then for 119 frames, part of the scene doesn't change, and that region of the screen requires less than 1% of the information of the raw video to render. So what problems exist with this model?

- Those dark pixels aren't *truly* dark, are they? It's not the *exact* same color from frame to frame, is it?
- What happens if I lose a frame or two? Video is often streamed via UDP without error recovery, and we're assuming lossless *transmission*.

There are two relevant tools to address these issues. 

- The color quantization of `yuv420p` collapses pixels, decreasing color resolution. Pixels are now more likely the exact color between frames.
- Whole "i-frames" (a.k.a. key or anchor frames) serve as error-recovery points. Have you ever seen video glitch out for a few seconds, usually with lots of grey boxing and artifacting around moving objects? The decoder lost a few frames, and probably recovered after using an i-frame.


### So how do we get the luminance value for a frame?

Firstly, we have to get the frame. We have to find the i-frame before the timestamp we want, and perform video decoding until we reach that timestamp. This is expensive.

We can also just grab the luminance value of the nearest preceding i-frame. While your gut reaction is probably "what if a scene transition happens in those few seconds before reaching the frame", consider the perspective of the video encoder:

- An i-frame is necessarily a complete[^1] frame, because the decoder needs to use it to recover from loss
- i-frame insertion location is very flexible[^3]
- scene transitions usually involve changing most pixels, so make great candidate i-frames

So, when grabbing luminance from the nearest iframe, opting not to decode video up to a precise timestamp is often fine. Further, consider the case where a scene transition occurs *while a subtitle is still rendered*. The subtitle will remain a potentially annoying brightness value, unless split into multiple renderings of the same subtitle. So there's already an unsolved brightness case involving scene transitions that can't be easily solved[^2] without integrating the video player's subtitle renderer.

This was the logic underpinning the `--fast` option, and in testing I didn't notice any difference using it.

Regardless, once we're there, we simply have to average the luminance value (the "Y-channel") of every 2x2 `yuv` pixel grid[^4]. These are all `ffmpeg` calls that are blessedly abstracted beneath me.


### What do we do with the luminance value of the frame?

Subtitles' luminance should more closely match the frame they inhabit. Darkening subtitles when Y is dark, and brightening them when Y is bright. In practice, since all subtitles are rendered `#FFFFFF`, I just make them greyer, hence the name. The stupid solution is to just average the 3 channels of `#7F7F7F`, the RGB color midpoint, with the Y value, which is already a byte. I haven't played with nonlinear interpolation, because the naiive lerp solves the blinding-HDR-subtitle problem pretty well, to be honest.

I do think there's probably a better non-lerp. I also played with averaging `#FFFFFF` and frame luminance, but found it to still often be too bright[^5]. Lerping is typically defined as:

`Lerp(x) = a(1-x) + b(x)`

where X ∈ [0, 1]. tweaking the exponent like so:

`Lerp(x) = a(1-x^2) + b(x^2)`

is a (quadratic) nonlinear interpolation. I'm guessing it'll look best with a nonlinear interp between extracted-luminance and `#FFFFFF` at an exponent of around `1.5`?

### What Now?

I don't consider this project finished because honestly I think it wants to be a VLC plugin. A subtitle post-video-download step is more suited to something like [alass](https://github.com/kaegi/alass), a far more useful project for subtitle display.

As far as I searched[^6], nobody else has bothered trying to automate an open-source solution to this incredibly niche problem.


[^1]: it's not a *raw* frame, because rgb->yuv still occurred, but it's extremely close.

[^2]: this is doable within the SRT format, but it's unclear to me if most renderers would flicker the subtitle, and I didn't bother experimenting in this script.

[^3]: most encoders default to 5 seconds maximum between i-frames

[^4]: you could certainly make the case to me that only the luminance around where the subtitle is actually rendered should be displayed, and that this would be faster to calculate. It just introduces the edge case where the subtitle region happens to be vastly different than the rest of the frames, making them potentially crowded-out. I don't know what that case looks like in practice.

[^5]: if you're wondering, the main video file I used to test the dark-video-with-white-subtitle problem was Silo S02E06. When I initially extracted the Y channels, I thought I did something wrong and clamped them to 6 bits somehow, because the highest value was I think 63. Nope, that was just the brightest frame in the entire episode, which, as the name implies, takes place underground.

[^6]: about a half-dozen google searches, a github search, a kagi search, even on marginalia, and I think Plex's(?) forums
