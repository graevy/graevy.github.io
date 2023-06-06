---
title: "migration"
date: 2023-03-28T04:33:25-07:00
draft: false
---

After my digitalocean team dissolved, I migrated from a $4/mo droplet to github pages for free. I:

- could've avoided webhooks entirely
- saved money in the process

But, I:

- centralized my services,
- lost privacy,
- can only serve static pages

so who's to say.

Surprisingly, the build pipeline was the easiest migration component, and enabling https was the hardest; CNAME records interfere with SSL certs. I hung on some DNS records until I decided to remove the cloudflare step. I'm not sure if I ever bothered setting up https on the droplet, but it definitely would've been easier with a shell.

Images are still broken; I've procrastinated learning git-lfs; that seems to have paid off now that my environment is centralized. Clear next step given that I'm waiting to test covid-negative before going to any meetup to resume spot-welding broken battery components.

Update: while I fixed git lfs rendering issues[^1], it is a smooth yak. The current [pipeline](/resources/cam.sh) for a photo is:
- Phone camera, adb over network on, `adb connect $PHONEIP:5555` or just plug it in and `adb devices` to start the daemon
- `adb shell ls in_dir | rg IMG | sort -h | tail -n $1` to get the filenames of the `$1` latest photos taken on the phone sorted by timestamp
- `adb exec-out cat in_dir/photo.jpg | convert - -resize 1200x800 out_dir/$2/photo.jpg` to transcode the raw photo with imagemagick's convert function (rather than serve 6MB images[^3]) and dump the result here.

I don't run this next portion because it interacts with the internet, so it's a bad solution, but 
- `git lfs pull`
- return githubusercontent URLs to stdout for `script no_of_latest_photos -static_subdir dir | xclip -sel c` or similar


[^1]: Manually editing `.gitattributes` requires running `git lfs pull`, something I only learned about after reading internal Amazon documentation; git lfs has sparse and auto-generated docs. I am too spoiled and assume that modules will simply know when I've updated their config files.

[^3]: It might be simpler/safer to use `mtpfs`/similar but I already use adb for everything
