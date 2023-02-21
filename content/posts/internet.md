---
title: "Internet tips"
date: 2023-02-20T20:41:32-08:00
draft: false
---

I'm writing this post for my friends who know how to use the internet, but not effectively or safely. I'll try to keep this up to date.

The last update was: Feb 20 2023


# Browser

Chrome is phasing out privacy features and adblockers, and its browser monopoly adversely affects web development.
Vivaldi is pretty nice. It has good tab management, integrated mail, calendar, etc. and it's mostly open source.
Brave is infamously headed by (among other things) a covid denier, but does have features like integrated ad blocking.
Opera has good media integration.
Firefox is open source, customizable, and the most popular alternative.

Firefox addons I recommend to everyone in order of importance:
- Ublock Origin
- I still don't care about cookies
- SponsorBlock
- Bypass Paywalls Clean
- Alternative Player for Twitch.tv (this hides ads)
- Link Cleaner
- Tab Session Manager

Sometimes addons will break a webpage. Most browsers have a safe mode (loads a new menu for this) for this.

Mozilla maintains [a page](https://support.mozilla.org/en-US/kb/switching-chrome-firefox) detailing how to switch from chrome to firefox

# Searching tips

Search engines don't work anymore because of SEO and a lack of financial incentive to fix the problem. Search engines have a general syntax you can use to search better. It's helpful to know that:
- `seattle "vegan" restaurants` will only return results containing the keyword `vegan`
- `seattle restaurants -pinterest -vegan` will only return results that don't contain `vegan` or `pinterest`
- `seattle restaurants site:reddit.com` will only return results from reddit;
- `seattle "vegan" restaurants -pinterest site:reddit.com` will give you reddit posts containing the word vegan about seattle restaurants that don't have pinterest anywhere in their body or title.

I use duckduckgo, but it isn't much better than google. I find most people sitesearch reddit (appending site:reddit.com) to find product reviews that aren't sponsored.

To find approximate knowledge that isn't monetized, AI chatbots like chatGPT are a great way to search for things, because they're trained on the internet. I just searched "what is the purpose of magnetic eye shadow pallette"; I only saw ads. Here is a dialogue I just had with chatGPT:

![](/images/eyeshadow.png)

AI chatbots are bad at giving you exactly correct answers. I just asked chatGPT what 2+3-5+12*4/2 is (24); it said 10.

[Archive.org](https://archive.org/) saves old webpages. This is very important work, and very useful. For instance, to find the darknet link below, I searched `darknetmarkets 2022 site:reddit.com`, looked for the first banned subreddit I could find, put its URL into the internet archive, retrieved an old version of the site, and found a collection of helpful links in its sidebar.

# TOR/VPNs and the darkweb

[The Onion Router](https://www.torproject.org/download/) bounces your connection around dozens of different anonymous nodes before reaching an endpoint. This is a secure way to access the internet, generally, but is slow. Properly configured, TOR is an acceptable way to use the darkweb. [Tails](https://tails.boum.org/) is a portable linux distribution that pre-configures TOR.

VPNs are a node between user and endpoint; you have to trust them to use them. [Mullvad](https://mullvad.net/en/) is a frequently recommended vpn service. These are not as private as people tend to believe.

Darknet markets come and go all the time. At the moment, https://darknet.markets/ has a lot of links. Monero is the current anonymous cryptocurrency of choice.

# Piracy

Here is an overview of content-specific internet piracy ecosystems.

### Explanation of torrenting

You need a program to handle torrenting. [qBittorrent](https://qbittorrent.org/download.php) is open source (anyone can view all of its code, making it more secure and ad-free). You get parts of files from anyone else who has them and is online (this part is secure because of the torrent protocol). Torrents themselves can be viruses because anyone can upload one. To actually download a torrent, you have to browse a torrent tracker to get either "magnet link"s or .torrent files for a torrent client to use.

Sometimes, Disney or some other media giant will serve you your torrents. They do this to get your IP address, to nag your ISP, to nag you. You can ignore these emails; ISPs want your money, so they won't cancel your service. If you get enough emails, they'll slap you on the wrist somehow. Using a VPN will stop the letters.

Note that not all torrenting is illegal; it's a very helpful way to share files without a dedicated server. I have downloaded device drivers with torrent clients, public domain works, etc.

### Basic virus avoidance techniques

Know your file extensions: a .exe file is a windows executable file for running a program. If you download music, and it's a .exe file, that's probably a virus. If you don't know an extension, search it online.

Some downloads will require admin permissions. Game installers are a good example; video files are not.

This post has resources that I "trust". If something is a maybe-virus, you can use [virustotal](https://virustotal.com). You'll get more false results depending on the file; I've never seen a windows cracking tool pass an antivirus scan or a video file fail one.

If you just search something like "mobilism" (mentioned later), you'll run into fake websites. Just search reddit to get the URL.

I don't know of any good free antiviruses anymore.

If you get a virus, you probably won't know about it. Every few years, reinstall your OS from a flash drive, and then format the drive.

### Windows

This is a lot less risky than it used to be because most cracks now use official microsoft windows images. 
- Get latest windows image from microsoft
- Create an installation USB with [rufus](https://rufus.ie/en/) (Windows), Disk Utility (mac), or the dd command (linux)
- Go through the installation process, select Pro or Pro N (Pro N is the EU-compliant version with less bloat)
- Go to [this github](https://github.com/massgravel/Microsoft-Activation-Scripts), open powershell as an admin, and crack it
- If you installed Pro N, specifically, you have to install the Windows Media Feature Pack; look it up
- I recommend [tronscript](https://old.reddit.com/r/tronscript) for debloating and [chocolatey](https://chocolatey.org) for package managing


### Music

It's hard to get a virus from downloading music, not that anyone does that anymore. If you want to actually download music, [rutracker](https://rutracker.org) is my favorite pubic tracker for music (rip what.cd).

What you're probably looking for is a cracked spotify app in Android Apps below. You might also be interested in [yt-dlp](https://github.com/yt-dlp/yt-dlp/releases).

### Video

Low risk for the same reason as above; video files don't have elevated permissions. Get these by going to your public tracker of choice (I recommend [1337x](https://1337x.to) first, then [thepiratebay](https://thepiratebay.org)). Private trackers have the best selections; those typically involve getting an invite and passing a screening process.

Use [VLC](https://www.videolan.org/) to watch videos.

Check the "Download in sequential order" button in qbittorrent so you can watch videos before you've finished downloading them. You generally only need to download about 5-10% of a video before you can just stream it if your connection is fast enough.

To help tie things together, I asked chatGPT: "provide a glossary of terms (such as "x265", or "5.1", or "BRRip") used to describe video hosted on torrent trackers" and received this response before it was cut off due to length:

```
Sure, here's a glossary of terms commonly used to describe video hosted on torrent trackers:

x265: An advanced video compression format that provides better video quality than the older x264 format, while using less storage space and bandwidth.

5.1: Refers to a type of audio configuration that includes five channels of audio (left, center, right, left surround, and right surround) plus a separate subwoofer channel for bass frequencies. This configuration is commonly used in home theater systems.

BRRip: A video format that stands for "Blu-ray rip." It refers to a high-quality video that has been ripped directly from a Blu-ray disc.

CAM: Short for "camera." A CAM copy is a low-quality recording of a movie that was captured in a movie theater using a handheld camera. The audio and video quality are typically poor.

DVDRip: A video format that stands for "DVD rip." It refers to a high-quality video that has been ripped directly from a DVD.

HDRip: A video format that stands for "High Dynamic Range rip." It refers to a video that has been encoded with HDR, which provides a wider range of colors and better contrast than standard video.

WEB-DL: A video format that stands for "web download." It refers to a video that has been downloaded from an online streaming service, such as Netflix or Amazon Prime Video.

HDTV: Stands for "high-definition television." It refers to a television format that provides a higher resolution and better image quality than standard definition television.

Remux: A video format that refers to a high-quality video that has been copied from a Blu-ray or DVD disc without any compression or loss of quality.

SD: Stands for "standard definition."
```

### Android Apps

Get illicit APKs from [mobilism](https://forum.mobilism.org/index.php). This ecosystem's pretty seedy.

Apple users: you need to jailbreak your device.

### Software

This is the hardest one to do properly; I think it's the riskiest. Find popular torrents on a public tracker and roll those dice. Use a virtual machine; that's beyond the scope of this post. Occasionally a repacker will host what you're looking for.

### Games

There is a bounty ecosystem where people donate to reputable game crackers. Don't get games off of public trackers like thepiratebay. Two of the most reputable crackers are [fitgirl](https//:fitgirl-repacks.site) and [dodi](https://dodi-repacks.site). If they don't have what you're looking for, go check [the CrackWatch subreddit](https://old.reddit.com/r/CrackWatch) to find a reputable cracker who does.

### Books

[libgen](https://gen.lib.rus.ec) is the best. Myanonamouse is a good private tracker for books that will let you in after an interview. The piracy subreddit maintains a list of book trackers. A generic web search with pdf, epub, etc. extensions is a last resort.

### Papers

Sci-hub's uptime is very intermittent. You should actually just email paper authors and they'll send you a copy.