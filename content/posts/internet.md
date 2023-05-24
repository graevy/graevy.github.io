---
title: "Internet harm reduction"
date: 2023-02-20T20:41:32-08:00
draft: false
---

This is a harm reduction guide for my friends who risk malware and surveillance, mostly while stealing things on the internet, but also just by browsing unhygenically.

Last updated: May 14 2023 (please [email me](mailto:avry@pm.me) if anything needs attention)

# Browser

Chrome is phasing out privacy features and adblockers, and browser monopolies are bad, so please use a good browser:
- Firefox is [open source](https://opensource.com/resources/what-open-source), customizable, and the most popular alternative (that isn't Edge or Safari)
- Vivaldi is a mostly open-source power-user browser, with tab management, integrated mail, calendar, translation, etc., but forks chromium

Firefox addons I recommend[^7] to everyone in order of importance:
- Ublock Origin
- I still don't care about cookies
- SponsorBlock (skips youtube sponsored segments)
- Alternative Player for Twitch.tv (hides ads)
- Link Cleaner
- Tab Session Manager (vivaldi does it better)
- [Bypass Paywalls Clean](https://gitlab.com/magnolia1234/bypass-paywalls-firefox-clean) (can't be installed regularly due to DMCA violation[^18]. download the xpi release and open it with firefox)

Sometimes addons will break a webpage. Most browsers have a safe mode for this, which loads a separate browser instance with zero customization.

If you aren't going to use a dedicated password manager like [Bitwarden](https://bitwarden.com/), firefox accounts have a sync feature between devices which also tracks public password database leaks. I recommend using the Secure Password Generator addon for whenever firefox's generator doesn't recognize a password field.

If you don't have enough RAM for your appalling browser tab habits, [increasing `browser.low_commit_space_threshold_mb` makes firefox unload unused tabs](https://web.archive.org/web/20230216193845/https://dev.to/msugakov/taking-firefox-memory-usage-under-control-on-linux-4b02) for better-than-chrome multitasking.

Mozilla maintains [a page](https://support.mozilla.org/en-US/kb/switching-chrome-firefox) on switching from chrome to firefox.

# Searching tips

There's a lot of misinformation and advertising in search results because of Search Engine Optimization and a lack of financial incentive to fix the problem. Search engines have a syntax. It's helpful to know that, generally:
- `seattle "vegan" restaurants` will only return results containing the keyword `vegan`
- `seattle restaurants -pinterest -vegan` will only return results that don't contain `vegan` or `pinterest`
- `seattle restaurants site:reddit.com` will only return results from reddit;
- `seattle "vegan" restaurants -pinterest site:reddit.com` will give you reddit posts containing the word vegan about seattle restaurants that don't have pinterest anywhere in their body or title.

I find most people sitesearch reddit (appending `site:reddit.com`) to find product reviews that aren't sponsored.

For ***approximate*** knowledge that isn't monetized, instruction-tasked LLMs like chatGPT are a great way to search for things, because they're trained on the internet. I just searched "what is the purpose of magnetic eye shadow pallette"; I only saw ads. Here is a dialogue I just had with chatGPT:

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/eyeshadow.png)

[Archive.org](https://archive.org/) saves old webpages. This is very important work, and very useful. To find the link below, I searched `darknetmarkets 2022 site:reddit.com`, looked for the first banned subreddit I could find, put its URL into the internet archive, retrieved an old version of the site, and found a collection of helpful links in its sidebar.

# TOR/VPNs and the darkweb

[The Onion Router](https://www.torproject.org/download/) bounces your connection around dozens of different anonymous nodes before reaching an endpoint. This is a [generally](https://web.archive.org/web/20220821150904/https://arstechnica.com/information-technology/2013/09/majority-of-tor-crypto-keys-could-be-broken-by-nsa-researcher-says/) [secure](https://web.archive.org/web/20230122181201/https://gizmodo.com/fbi-tor-ip-address-muhammed-momtaz-al-azhari-isis-1849975153) way to access the internet, but is slow. Make sure you [properly configure](https://tb-manual.torproject.org/running-tor-browser/) TOR. [Tails](https://tails.boum.org/) is a portable linux distribution that pre-configures TOR, if you're both knowledgeable and paranoid.

VPNs are a node between user and destination. This means you connect to a website through a middleman, so that the website can't see your IP. The proxy can sell your [valuable](https://web.archive.org/web/20230224200913/https://www.statista.com/topics/1464/big-data/#topicOverview) data, which they as middlemen can neatly package. Any VPN service with an ad budget is selling that to remain competitive. Off the top of my head, PrivateInternetAccess & NordVPN also explicitly cooperate with states. [Mullvad](https://mullvad.net/en/) is a frequently recommended vpn service.

Darknet markets come and go all the time. At the moment, https://darknet.markets/ has a lot of links[^17]. You can only use these links in a TOR browser. Monero is the current anonymous cryptocurrency of choice; Bitcoin is more traceable.

# <a name="piracy"></a>Piracy

Here is an overview of content-specific internet piracy ecosystems. I only give frank overviews here because you can find more in-depth resources at [freemediaheckyeah](https://freemediaheckyeah.pages.dev/beginners-guide/) or [the piracy subreddit](https://old.reddit.com/r/piracy/).

### Explanation of torrenting

- Other people have copies of files you want
- You get `bits`[^11] of the files from whoever has them and is online
- Many small downloads sum to a `torrent` of data
- A `torrent client` connects you to `the swarm`: clients who are currently uploading/downloading those files
- Swarm joining instructions are inside a `magnet link` or a `torrent file`
- These links and files are typically hosted on websites called `torrent trackers`
- Torrent trackers try to prevent users from uploading viruses

### Torrenting's legal landscape

- Torrenting is only illegal when copyrighted data is exchanged, therefore:
    - the torrent software is itself perfectly legal,
    - the torrent tracker is legal[^14] because it doesn't host any copyrighted data; only references to it.
- Exchanging files reveals your `IP address` unless you use a `VPN` or `proxy`;
- Copyright holders can join the swarm and notify your Internet Service Provider
- Your `ISP` can nag you to stop torrenting, but they have a financial incentive to continue service and minimally legally comply
    - Never reply to these nags; you provide a paper trail
- Every now and then, a government will jail someone 

### Torrenting's virus landscape

Here are the popular[^15] reasons people make viruses for torrents. From most to least common:

1. To get your credentials.
    - Common. Hidden malware that waits for you to login somewhere and records it.
2. To leverage your hardware to provide value. Either your pc starts mining cryptocurrency, you inadvertently participate in a [botnet](https://www.malwarebytes.com/botnet), or both[^13]
    - Common because target diversity is great for botnets and people who torrent games usually have good mining GPUs
3. To install ransomware: holding your files hostage until a ransom is paid.
    - Rare because distributing ransomware quickly gets you banned from any decent tracker, individuals rarely pay out, and that level of system access is hard to obtain

So, when torrenting anything with elevated permissions, we're really only worried about 1 and 2; the goal of someone poisoning torrents is to go undetected. You just have to wipe your system periodically, or when the GPU gets suspiciously warm. I know it's annoying.

Some miscellaneous tips:

- Torrented media rarely contains viruses; torrented programs often contain viruses
- New torrents are more likely to contain viruses than old torrents by virtue of content moderation
    - Trackers also usually have comments sections for each torrent
- Free antiviruses aren't really better than OS defaults e.g. Windows Defender
- If you want to take a chance on a file, scan it with [virustotal](https://virustotal.com)
- Wikipedia software articles usually have a link to their homepage to prevent you from getting phished:
    - `facebook.co`, `facebook.net`, etc. are *not* the same websites as `facebook.com`, and can appear *identical*, down to the styling of the page or the URL you click: [facebook.com](https://notfacebook.com)
    - `facebook.com.market` is a subdomain of `com.market`. Don't fall for this one; it's embarassing; I'll judge you

### What torrent client should I use?

- [Transmission](https://transmissionbt.com/) is open source, cross platform, and beginner friendly
- [qBittorrent](https://www.qbittorrent.org/) is open source and cross platform
- Android: [LibreTorrent](https://f-droid.org/packages/org.proninyaroslav.libretorrent/) is open source
- iOS: [iTorrent](https://github.com/XITRIX/iTorrent/releases) is open source

Use a different torrent tracker for whatever content you're downloading. The best general purpose tracker is [1337x](https://1337x.to), then whatever's on reddit's [piracy megathread](https://www.reddit.com/r/Piracy/wiki/megathread/).

## Where do I pirate \_\_\_\_\_?

### Windows

This is a lot less risky than it used to be because most cracks now use microsoft's windows images. To crack an active windows installation, go to [this github](https://github.com/massgravel/Microsoft-Activation-Scripts)[^9] and follow the instructions (you want to use HWID). Remember to open powershell/terminal *as an administrator*.

To install windows:
- Get latest windows image from microsoft ([10](https://www.microsoft.com/en-us/software-download/windows10ISO) [11](https://www.microsoft.com/en-us/software-download/windows11/))
- Take a thumb drive and either [rufus](https://rufus.ie/en/) (windows), Disk Utility (mac), or something like `dd if=/path/to/iso of=/path/to/usb conv=fsync bs=8M` (linux) to make an installation USB
- Reboot with the USB plugged in. You will usually have to [enter your BIOS](https://www.wikihow.com/Enter-BIOS) (or boot menu), typically by holding down the f2 (or f8, f12, insert, delete...) key, booting from the USB or changing your boot order to prioritize it.
- Install Windows. Select Pro or Pro N (Pro N is the EU-compliant version with less bloat, but you'll want to install the Windows Media Feature Pack yourself)
- I recommend [tronscript](https://old.reddit.com/r/tronscript) for debloating[^5] and [chocolatey](https://chocolatey.org) for package managing[^6]
- An example tron command for a `tron.bat` file downloaded to `C:\Users\a\Downloads\Tron` on a fresh machine is `C:\Users\a\Downloads\Tron\tron.bat -a -sa -sd -scc -v` (skipping antivirus scans, defrag, and cookies). Run this in cmd as an administrator.
- Crack windows using the *admin* powershell github commands in the [link](https://github.com/massgravel/Microsoft-Activation-Scripts) above

### Music

It's hard to get a virus from downloading music, not that anyone does that anymore. [rutracker](https://rutracker.org) is my favorite public tracker for music[^16]; you need to make an account and the whole website is russian so a translation browser extension is a good idea. [Soulseek](https://www.slsknet.org/) has a good english-language selection but it's kindof closed off from the rest of the torrent ecosystem. 

You're probably looking for a cracked spotify app in Apps below. [revanced](https://revanced.io/)/[newpipe](https://newpipe.net/) will handle youtube. These projects come and go.

For desktops, [yt-dlp](https://github.com/yt-dlp/yt-dlp/releases) downloads youtube media, and just using the web version of spotify with ublock origin on firefox should block its ads.

### Video

Low risk[^10] for the same reason as above; video files don't need elevated permissions. Get these by going to your public tracker of choice (I recommend [1337x](https://1337x.to) first, then [thepiratebay](https://thepiratebay.org))[^2]. Private trackers have the best selections; those typically involve being invited and passing a screening process.

When starting a new torrent, downloading in "sequential order" or similar lets you functionally stream video[^8]. You only need to download about 5-10% of a video before you can play it if your connection is fast enough. Use [VLC](https://www.videolan.org/) or [MPC-HC](https://github.com/clsid2/mpc-hc/releases) to watch videos.

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

Apple users: jailbreaking is outside the scope of this guide. [sideloaded](https://www.reddit.com/r/sideloaded/) is a community for loading custom apps that don't require jailbreaking.

### Software

This is the riskiest. I'll direct you to the [piracy megathread](https://www.reddit.com/r/Piracy/wiki/megathread/software_downloads), which vouches for [m0nkrus](https://w14.monkrus.ws/)' repacks. Otherwise, find torrents on a public tracker and roll the dice. Use a [virtual machine](https://www.virtualbox.org/wiki/Downloads)[^4] for one-shot tasks; that's also beyond the scope of this guide.

### Games

There is a bounty ecosystem where people donate to reputable game crackers[^12]. Don't get games off of public trackers like thepiratebay if you can avoid it. Two of the most reputable crackers are [fitgirl](https://fitgirl-repacks.site)[^1] and [dodi](https://dodi-repacks.site)[^1]. If they don't have what you're looking for, go search [the CrackWatch subreddit](https://old.reddit.com/r/CrackWatch) to find a reputable cracker who does.

### Books/academic papers

[libgen](https://gen.lib.rus.ec) is the best[^1]. [Myanonamouse](https://www.myanonamouse.net/) is a good private tracker for books that will let you in after a technical interview. The [piracy megathread](https://www.reddit.com/r/Piracy/wiki/megathread/reading_material_and_elearning) maintains a list of book trackers; these are always coming and going. A filetype search[^3] with pdf, mobi, epub, etc. extensions is a last resort.

For papers specifically, check libgen, then [sci-hub](https://sci-hub.se/) (mediocre uptime; blame the lawsuits), then [academictorrents](https://academictorrents.com/), then the [piracy megathread](https://www.reddit.com/r/Piracy/wiki/megathread/reading_material_and_elearning), then...just email paper authors and they'll usually send you a copy. You might be able to find a non-paywalled copy on google scholar. Extensions like Bypass Paywalls Clean or Unpaywall have historically been bad at papers.

Have some junk text to make footnotes better[^50]



[^1]: Technically not a torrent tracker ("legal miracle"?) because it hosts links to direct downloads rather than peer-to-peer downloads

[^2]: Thepiratebay has a reputation for viruses, and site VIPs are not to be trusted

[^3]: Append `filetype:pdf` to a search to only return direct links to pdfs, for example

[^4]: VMs are operating-systems-inside-operating-systems that are slower than normal OSes, but if your VM gets a virus, you don't exactly care. [VirtualBox](https://www.virtualbox.org/wiki/Downloads) is what most people use, but I rarely deal with them and they're complicated to setup securely. Good for something like pirated photoshop, ableton, older games, ~~installing BonziBuddy, Monkey, Gator, and Prody Parrot to watch them duke it out,~~ etc.

[^5]: Bloatware refers to unwanted bundled software (PUPs); debloating is the process of removing bloatware, often complicated by e.g. the financial incentive of microsoft to place ads in the start menu.

[^6]: A package manager downloads, installs, uninstalls, and updates software for you. Entering e.g. `choco install firefox audacity vlc qbittorrent` in *admin* powershell installs these apps; `choco uninstall audacity` will uninstall audacity only if chocolatey installed it; `choco upgrade all` updates every chocolatey-managed app on your machine at once. Anyone allergic to powershell can use Chocolatey GUI, which is pretty mediocre. Package managers only manage apps they installed, so they're best configured right after a full wipe. This is how linux handles software, grafted onto windows.

[^7]: People usually recommend installing privacy addons e.g. Privacy Badger, Privacy Possum, Don't Track Me Google... I have three reasons not to tell new firefox users to install them:
    - they can break websites
    - they can increase vulnerability to [fingerprinting](https://www.mozilla.org/en-US/firefox/features/block-fingerprinting/)
    - firefox rapidly adopts popular privacy addon features when they don't conflict with mozilla's financial interests

[^8]: By default, swarms serve seemingly random chunks of files. Sequential downloading orders those chunks first -> last. This isn't default behavior because [it isn't healthy for swarms](https://web.archive.org/web/20230315012054/https://wiki.vuze.com/w/Sequential_downloading_is_bad)

[^9]: Github is actually owned by microsoft; this page is functionally a github canary. [Here](https://web.archive.org/web/20230515185526/https://github.com/massgravel/Microsoft-Activation-Scripts)'s an archive.org link.

[^10]: [But not no-risk](https://threatpost.com/high-risk-vlc-media-player-bugs/147503/). My hope is that by scaring you and providing OS reinstallation guides you'll reinstall your OS every few years and I won't have to crowdfund hardware replacements for your mined laptop gpu.

[^11]: Hence "bit-torrent protocol"

[^12]: Usually: eastern European genius cohorts too mentally unstable to emigrate for the wages befitting their cybersecurity niche. Uncommonly: skilled, elitist, anarchist remnants of the 90's warez scene.

[^13]: It should be noted that historically this was a pretty symbiotic relationship. You save money, someone gets a botnet member (you usually never noticed), everyone wins. If you caught too many botnets, you'd reinstall your OS, and your PC would be fast again. Crypto mining and online payments have completely upended this dynamic. Now, viruses want your credentials/silicon with a vengeance.

[^14]: Some jurisdictions obligate the torrent tracker to remove illegal content references. This is a flimsy legal argument with a major corporate backing; creative ccTLDs (.to, .cr, .vu...) make this difficult to enforce. In the absence of jurisdiction, vested interests will DDoS trackers to weaken their reliability.

[^15]: Source: my ass. See also: [white hats](https://en.wikipedia.org/wiki/White_hat_(computer_security)), "because they can", [cyberpunk conspiracies using you as a transmission vector](https://en.wikipedia.org/wiki/Stuxnet)

[^16]: rip what.cd

[^17]: For actually good links, find darkweb forums and lurk until you understand the current ecosystem.

[^18]: That's how you know it's good.

[^50]: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.