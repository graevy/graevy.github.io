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

Darknet markets come and go all the time. At the moment, https://darknet.markets/ has a lot of links. You can only use these links in a TOR browser. Monero is the current anonymous cryptocurrency of choice; Bitcoin is more traceable.

# Piracy

Here is an overview of content-specific internet piracy ecosystems. I only give frank overviews here because you can find more in-depth resources available at sites like [freemediaheckyeah](https://freemediaheckyeah.pages.dev/beginners-guide/) or [the piracy subreddit](https://old.reddit.com/r/piracy/)

### Explanation of torrenting

- Other people have copies of files you want
- You get pieces of the files from whoever has them and is online
- Many small downloads add up to a *torrent* of data
- A *torrent client* connects people who are uploading and downloading
- Everyone currently exchanging files is part of *the swarm*
- Joining a swarm requires a *magnet link* or a *torrent file*
- These links and files are hosted on a website called a *torrent tracker*

What torrent client should I use?
- [qBittorrent](https://www.qbittorrent.org/) is open source and cross platform
- [Transmission](https://transmissionbt.com/) is popular for its low resource consumption
- Android: [LibreTorrent](https://f-droid.org/packages/org.proninyaroslav.libretorrent/) is open source
- iOS: [iTorrent](https://github.com/XITRIX/iTorrent/releases) is open source

Use a different torrent tracker for whatever content you're downloading. The best general purpose tracker is [1337x](https://1337x.to), then whatever's on reddit's [piracy megathread](https://www.reddit.com/r/Piracy/wiki/megathread/).

### Virus safety

- The torrent tracker tries to prevent people from uploading *viruses*
- Copyright holders will sometimes join the swarm to track your *IP address* and nag your internet provider
    - Virtual Private Networks (VPNs) and proxies can hide your IP address behind another
    - Maybe try a less popular torrent for the latest TV show episode release instead
- If you want to take a chance on a file, scan it with [virustotal](https://virustotal.com)
- Know your file extensions: a .exe is a windows program, not a music file
- Don't get phished:
    - Try to get a URL secondhand through wikipedia or something before searching
    - `facebook.com.market` is a subdomain of `com.market`
    - `facebook.co`, `facebook.net`, etc. are *not* the same websites as `facebook.com`
- You usually won't know if you have a virus; you should wipe your drive and reinstall your OS every once in awhile
- Free antiviruses aren't better than whatever is bundled with your OS now

## Where do I pirate \_\_\_\_\_?

### Windows

This is a lot less risky than it used to be because most cracks now use microsoft's windows images. To crack an active windows installation, go to [this github](https://github.com/massgravel/Microsoft-Activation-Scripts) and follow the instructions (you want to use HWID). Remember to open powershell/terminal *as an administrator*.

To install windows:
- Get latest windows image from microsoft ([10](https://www.microsoft.com/en-us/software-download/windows10ISO) [11](https://www.microsoft.com/en-us/software-download/windows11/))
- Create an installation USB with [rufus](https://rufus.ie/en/) (windows), Disk Utility (mac), or something like `dd if=/path/to/iso of=/path/to/usb conv=fsync bs=8M` (linux)
- Reboot with the USB plugged in. You will usually have to [enter your BIOS](https://www.wikihow.com/Enter-BIOS) (or boot menu), typically by holding down the f2 (or f8, f12, insert, delete...) key, booting from the USB or changing your boot order to prioritize it.
- Go through the installation process, select Pro or Pro N (Pro N is the EU-compliant version with less bloat, but you'll want to install the Windows Media Feature Pack yourself)
- I recommend [tronscript](https://old.reddit.com/r/tronscript) for debloating and [chocolatey](https://chocolatey.org) for package managing
- An example tron command for a `tron.bat` file downloaded to `C:\Users\a\Downloads\Tron` on a fresh machine is `C:\Users\a\Downloads\Tron\tron.bat -a -sa -sd -scc -v` (skipping antivirus scans, defrag, and cookies). Run this in cmd as an administrator.
- Crack windows using the *admin* powershell github commands in the [link](https://github.com/massgravel/Microsoft-Activation-Scripts) above

### Music

It's hard to get a virus from downloading music, not that anyone does that anymore. [rutracker](https://rutracker.org) is my favorite public tracker for music (rip what.cd); you need to make an account and the whole website is russian so a translation browser extension is a good idea. [Soulseek](https://www.slsknet.org/) has a pretty good english-language selection but it's kindof closed off from the rest of the torrent ecosystem. 

You're probably looking for a cracked spotify app in Apps below. [revanced](https://revanced.io/)/[newpipe](https://newpipe.net/) will handle youtube. These projects come and go.

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

### Apps

Android users: get illicit APKs from [mobilism](https://forum.mobilism.org/index.php)[^1]. This ecosystem's pretty seedy. [f-droid](https://f-droid.org/) is a package manager like the google play store, except it only has free open source apps. F-droid's app is notoriously buggy so try some frontends like Neo Store or Droid-ify.

Apple users: jailbreaking is outside the scope of this guide. [sideloaded](https://www.reddit.com/r/sideloaded/) is a community for loading custom apps that don't require jailbreaking. I can't personally vouch for them, though.

### Software

This is the riskiest. I'll direct you to the [piracy megathread](https://www.reddit.com/r/Piracy/wiki/megathread/software_downloads), which vouches for [m0nkrus](https://w14.monkrus.ws/)' repacks. Otherwise, find torrents on a public tracker and roll the dice. Use a [virtual machine](https://www.virtualbox.org/wiki/Downloads)[^4] if you can; that's also beyond the scope of this guide.

### Games

There is a bounty ecosystem where people donate to reputable game crackers. Don't get games off of public trackers like thepiratebay if you can avoid it. Two of the most reputable crackers are [fitgirl](https://fitgirl-repacks.site)[^1] and [dodi](https://dodi-repacks.site)[^1]. If they don't have what you're looking for, go search [the CrackWatch subreddit](https://old.reddit.com/r/CrackWatch) to find a reputable cracker who does.

### Books/academic papers

[libgen](https://gen.lib.rus.ec) is the best[^1]. [Myanonamouse](https://www.myanonamouse.net/) is a good private tracker for books that will let you in after a technical interview. The [piracy megathread](https://www.reddit.com/r/Piracy/wiki/megathread/reading_material_and_elearning) maintains a list of book trackers; these are always coming and going. A filetype search[^3] with pdf, mobi, epub, etc. extensions is a last resort.

For papers specifically, check libgen, then [sci-hub](https://sci-hub.se/) (mediocre uptime; blame the lawsuits), then [academictorrents](https://academictorrents.com/), then the [piracy megathread](https://www.reddit.com/r/Piracy/wiki/megathread/reading_material_and_elearning), then...just email paper authors and they'll usually send you a copy. You might be able to find a non-paywalled copy on google scholar. Extensions like Bypass Paywalls Clean or Unpaywall have historically been bad at papers.



[^1]: Technically not a torrent tracker because it hosts links to direct downloads rather than peer-to-peer downloads

[^2]: Thepiratebay has a reputation for viruses, and site VIPs are not to be trusted

[^3]: Append `filetype:pdf` to a search to only return direct links to pdfs, for example

[^4]: VMs are operating-systems-inside-operating-systems that are slower than normal OSes, but if your VM gets a virus, you don't exactly care. [VirtualBox](https://www.virtualbox.org/wiki/Downloads) is what most people use, but I rarely deal with them and they're complicated to setup securely. Good for something like pirated photoshop, ableton, older games, ~~installing BonziBuddy, Monkey, Gator, and Prody Parrot to watch them duke it out,~~ etc.