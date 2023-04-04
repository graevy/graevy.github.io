---
title: "Internet harm reduction"
date: 2023-02-20T20:41:32-08:00
draft: false
---

This is a harm reduction guide for my friends who risk malware and surveillance, mostly while stealing things on the internet, but also just by browsing unhygenically.

Last updated: Apr 2 2023

# Browser

Chrome is phasing out privacy features and adblockers, and browser monopolies are bad, so stop using it!
- Firefox is open source, customizable, and the most popular alternative (that isn't Edge or Safari)
- Vivaldi is a mostly open-source power-user browser, with tab management, integrated mail, calendar, translation, etc., but forks chromium

Firefox addons I recommend to everyone in order of importance:
- Ublock Origin
- I still don't care about cookies
- SponsorBlock (skips youtube sponsored segments)
- [Bypass Paywalls Clean](https://gitlab.com/magnolia1234/bypass-paywalls-firefox-clean) (can't be installed regularly due to DMCA violation. download the xpi release and open it with firefox)
- Alternative Player for Twitch.tv (hides ads)
- Link Cleaner
- Tab Session Manager (vivaldi does it better)

Sometimes addons will break a webpage. Most browsers have a safe mode for this, which loads a separate browser instance with zero customization.

If you aren't going to use a dedicated password manager like [Bitwarden](https://bitwarden.com/), firefox accounts have a sync feature between devices which also tracks public password database leaks. I recommend using the Secure Password Generator addon for this.

If you don't have enough RAM for your appalling browser tab habits, [increasing `browser.low_commit_space_threshold_mb` makes firefox unload tabs](https://web.archive.org/web/20230216193845/https://dev.to/msugakov/taking-firefox-memory-usage-under-control-on-linux-4b02).

Mozilla maintains [a page](https://support.mozilla.org/en-US/kb/switching-chrome-firefox) on switching from chrome to firefox.

# Searching tips

There's a lot of misinformation and advertising in search results because of Search Engine Optimization (SEO) and a lack of financial incentive to fix the problem. Search engines have a general syntax you can use to search better. It's helpful to know that:
- `seattle "vegan" restaurants` will only return results containing the keyword `vegan`
- `seattle restaurants -pinterest -vegan` will only return results that don't contain `vegan` or `pinterest`
- `seattle restaurants site:reddit.com` will only return results from reddit;
- `seattle "vegan" restaurants -pinterest site:reddit.com` will give you reddit posts containing the word vegan about seattle restaurants that don't have pinterest anywhere in their body or title.

I find most people sitesearch reddit (appending `site:reddit.com`) to find product reviews that aren't sponsored.

For approximate knowledge that isn't monetized, AI chatbots like chatGPT are a great way to search for things, because they're trained on the internet. I just searched "what is the purpose of magnetic eye shadow pallette"; I only saw ads. Here is a dialogue I just had with chatGPT:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/eyeshadow.png)

AI chatbots are bad at giving you exactly correct answers. I just asked chatGPT what 2+3-5+12*4/2 is (24); it said 10.

[Archive.org](https://archive.org/) saves old webpages. This is very important work, and very useful. To find the darknet link below, I searched `darknetmarkets 2022 site:reddit.com`, looked for the first banned subreddit I could find, put its URL into the internet archive, retrieved an old version of the site, and found a collection of helpful links in its sidebar.

# TOR/VPNs and the darkweb

[The Onion Router](https://www.torproject.org/download/) bounces your connection around dozens of different anonymous nodes before reaching an endpoint. This is a [generally](https://web.archive.org/web/20220821150904/https://arstechnica.com/information-technology/2013/09/majority-of-tor-crypto-keys-could-be-broken-by-nsa-researcher-says/) [secure](https://web.archive.org/web/20230122181201/https://gizmodo.com/fbi-tor-ip-address-muhammed-momtaz-al-azhari-isis-1849975153) way to access the internet, but is slow. Make sure you [properly configure](https://tb-manual.torproject.org/running-tor-browser/) TOR. [Tails](https://tails.boum.org/) is a portable linux distribution that pre-configures TOR, if you're both knowledgeable and paranoid.

VPNs are a node between user and endpoint. This means you connect to a website through a middleman, so that the website can't see your IP. The proxy can sell your [valuable](https://web.archive.org/web/20230224200913/https://www.statista.com/topics/1464/big-data/#topicOverview) data, which they as middlemen can neatly package, and any VPN service with an ad budget is almost certainly doing that to remain competitive. Off the top of my head, PrivateInternetAccess & NordVPN also explicitly cooperate with states. [Mullvad](https://mullvad.net/en/) is a frequently recommended vpn service.

Darknet markets come and go all the time. At the moment, https://darknet.markets/ has a lot of links. You can only use these links in a TOR browser. Monero is the current anonymous cryptocurrency of choice; Bitcoin is traceable.

# Piracy

Here is an overview of content-specific internet piracy ecosystems.

### Explanation of torrenting

You get parts of files from anyone else who has them and is online. You need a program to handle torrenting. [qBittorrent](https://qbittorrent.org/download.php) is open source. Torrents can be viruses because anyone can upload one. To actually download a torrent, you have to browse a torrent tracker to get either "magnet link"s or .torrent files for a torrent client to use.

Sometimes, Disney or some other media giant will serve you your torrents. They do this to get your IP address, to nag your ISP, to nag you. You can usually ignore these emails; ISPs want your money. If you get enough emails, they'll slap you on the wrist. A VPN will stop the emails.

### Basic virus avoidance techniques

Know your file extensions: a .exe file is a windows executable file for running a program. If you download music, and it's a .exe file, that's a virus. If you don't know an extension, search it online. Installers need admin permissions; a game torrent will need admin permissions, but a video file asking for them is a virus.

Search results are full of fake websites identical to the real one except by their URL. Their purpose is to try to "phish" credentials or get you to install a virus. Some examples:
- `facebook.com.market` is a subdomain of `com.market`
- `facebook.co`, `facebook.net`, etc. are *not* the same websites as `facebook.com`, and could be owned by anyone. The owners of facebook bought the `facebook.co` domain to prevent people from making this mistake, and the .net top-level-domain org won't sell `facebook.net`.

Try to get a URL secondhand through wikipedia or something before searching.

If you're taking a chance on something, you can use [virustotal](https://virustotal.com). You'll get more false results depending on the file; a windows cracking tool will fail an antivirus scan pretty much every time.

Free antiviruses aren't better than whatever is bundled with your OS. If you get a virus, you probably won't know about it. Periodically wiping your drive is the only reliable way to clear certain viruses.

### Windows

This is a lot less risky than it used to be because most cracks now use microsoft's windows images. To crack an active windows installation, go to [this github](https://github.com/massgravel/Microsoft-Activation-Scripts) and follow the instructions (you want to use HWID). Remember to open powershell/terminal *as an administrator*.

To install windows:
- Get latest windows image from microsoft ([10](https://www.microsoft.com/en-us/software-download/windows10ISO) [11](https://www.microsoft.com/en-us/software-download/windows11/))
- Create an installation USB with [rufus](https://rufus.ie/en/) (windows), Disk Utility (mac), or something like `dd if=/path/to/iso of=/path/to/usb conv=fsync bs=8M` (linux)
- Reboot with the USB plugged in; if you aren't taken to an installation screen, you need to reboot and [enter your BIOS](https://www.wikihow.com/Enter-BIOS), typically by holding down the f2 (or f8, f12, insert, delete...) key, and change your boot order to prioritize the plugged-in USB.
- Go through the installation process, select Pro or Pro N (Pro N is the EU-compliant version with less bloat, but you'll want to install the Windows Media Feature Pack yourself)
- I recommend [tronscript](https://old.reddit.com/r/tronscript) for debloating and [chocolatey](https://chocolatey.org) for package managing
- An example tron command for a `tron.bat` file downloaded to `C:\Users\a\Downloads\Tron` on a fresh machine is `C:\Users\a\Downloads\Tron\tron.bat -a -sa -sd -scc -v` (skipping antivirus scans, defrag, and cookies). Run this in cmd as an administrator.
- Crack windows using the *admin* powershell github commands in the [link](https://github.com/massgravel/Microsoft-Activation-Scripts) above

### Music

It's hard to get a virus from downloading music, not that anyone does that anymore. [rutracker](https://rutracker.org) is my favorite public tracker for music (rip what.cd); you need to make an account and the whole website is russian so a translation browser extension is a good idea.

You're probably looking for a cracked spotify app in Android Apps below. [revanced](https://revanced.io/)/[newpipe](https://newpipe.net/) will handle youtube. These projects come and go.

For desktops, [yt-dlp](https://github.com/yt-dlp/yt-dlp/releases) downloads youtube media, and just using the web version of spotify with ublock origin on firefox should block its ads.

### Video

Low risk for the same reason as above; video files don't need elevated permissions. Get these by going to your public tracker of choice (I recommend [1337x](https://1337x.to) first, then [thepiratebay](https://thepiratebay.org))[^2]. Private trackers have the best selections; those typically involve being invited and passing a screening process.

Check the "Download in sequential order" button in qbittorrent so you can watch videos before you've finished downloading them. You only need to download about 5-10% of a video before you can play it if your connection is fast enough. Use [VLC](https://www.videolan.org/) to watch videos. [MPC-HC](https://github.com/clsid2/mpc-hc/releases) is the only competitor I'm aware of.

I asked chatGPT: "provide a glossary of terms (such as "x265", or "5.1", or "BRRip") used to describe video hosted on torrent trackers" and received this response before it was cut off due to length:

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

Get illicit APKs from [mobilism](https://forum.mobilism.org/index.php)[^1]. This ecosystem's pretty seedy. [f-droid](https://f-droid.org/) is a package manager like the google play store, except it only has free open source apps. F-droid's app is notoriously buggy so try some frontends like Neo Store or Droid-ify.

Apple users: jailbreaking is outside the scope of this guide.

### Software

This is the riskiest. Find popular torrents on a public tracker and roll those dice. Use a [virtual machine](https://www.virtualbox.org/wiki/Downloads)[^4]; that's also beyond the scope of this guide. Occasionally a repacker will host what you're looking for.

### Games

There is a bounty ecosystem where people donate to reputable game crackers. Don't get games off of public trackers like thepiratebay. Two of the most reputable crackers are [fitgirl](https://fitgirl-repacks.site)[^1] and [dodi](https://dodi-repacks.site)[^1]. If they don't have what you're looking for, go check [the CrackWatch subreddit](https://old.reddit.com/r/CrackWatch) to find a reputable cracker who does.

### Books

[libgen](https://gen.lib.rus.ec) is the best[^1]. [Myanonamouse](https://www.myanonamouse.net/) is a good private tracker for books that will let you in after a technical interview. The [piracy subreddit](https://old.reddit.com/r/piracy) maintains a list of book trackers; these are always coming and going. A filetype search[^3] with pdf, epub, etc. extensions is a last resort.

### Papers

Sci-hub's been down for awhile. Just email paper authors and they'll send you a copy. You might be able to find a non-paywalled copy on google scholar. Extensions like Bypass Paywalls Clean or Unpaywall have historically been okay at this.


[^1]: Technically not a torrent tracker because it hosts links to direct downloads rather than peer-to-peer downloads

[^2]: Thepiratebay has a reputation for viruses, and site VIPs are not to be trusted

[^3]: Append `filetype:pdf` to a search to only return direct links to pdfs, for example

[^4]: VMs are operating-systems-inside-operating-systems that are slower than normal OSes, but if your VM gets a virus, you don't exactly care. [VirtualBox](https://www.virtualbox.org/wiki/Downloads) is what most people use, but I rarely deal with them and they're complicated to setup securely. Good for something like pirated photoshop, ableton, older games, ~~installing BonziBuddy, Monkey, Gator, and Prody Parrot to watch them duke it out,~~ etc.