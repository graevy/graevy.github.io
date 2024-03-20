---
title: "rooting"
date: 2024-03-19T13:52:11-07:00
draft: false
---

This is a step-by-step guide to rooting your phone properly, recited largely from memory, because people keep going to me for this.

This is intermediate difficulty; we'll be using a terminal (powershell on windows). You'll have to retrieve some information about your phone and your desired ROM that I can't easily help you get. If it doesn't work, bring your phone to open hack night so we can fix it.

### Pros/Cons of rooting

The Good:
- custom ROMs (lineage, graphene, copperhead, etc)
- debloating (cannot state how nice this is, especially on battery life)
- degoogling
- root-only package managers and apps
- extending your phone's end of life
- location spoofing
- if your hardware supports it: FM/AM radio, Fun With IR[^1]
- actually being able to use a file manager on android
- [free hotspotting](https://quatl.ooo/posts/hotspot/)

The Bad:
- the cat-and-mouse game of root detection and Magisk
- apps (particularly banking) finding out you're rooted
- degoogling
- the people who thanklessly maintain your ROM
- larger attack surface of most roms

The Ugly:
- bricking your phone
- boot-looping your phone
- random crashes, slowdowns, etc

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/boot-loops.jpg)

### OEM Unlocking[^3]

If you didn't buy a phone specifically for rooting, this might become much more annoying/impossible based on these results:

- Go to settings -> About phone
- Tap the build number button like 8 times (I'm not trolling you) to unlock developer options. It's under `system` settings
- Go to developer options and see if there's an OEM unlocking toggle.
- While you're here, enable USB debugging. Also, change the animation speeds to 0.5x, thank me later

If it's an easy toggle, great. If it's greyed-out, you typically have to get an unlock code from your phone manufacturer and insert it via fastboot (this is as annoying as it sounds). If it doesn't exist, you probably can't root the phone. Go to [xda-developers](https://xda-developers.com), find your phone subforum, and see if anyone has posted about rooting it. In ye olden days (a decade ago, when I first started rooting my phones), you typically had to use some privilege-escalation linux kernel vulnerability to unlock a bootloader, and if your phone is old enough, this is doable, good luck.

### Choosing a phone OS

If you have a pixel, you can choose a secure OS like [GrapheneOS](https://grapheneos.org/install/) (my choice), [Copperhead](https://copperhead.co/android/docs/), or [CalyxOS](https://calyxos.org/docs/guide/device-support/) (has some motorola/fairphone support!). Otherwise, you want [Lineage](https://wiki.lineageos.org/devices/)[^2], maybe [crDroid](https://crdroid.net/downloads) or something else [listed here](https://en.wikipedia.org/wiki/List_of_custom_Android_distributions) that is both open source and still developed. Another option might be decent; I haven't reviewed them in awhile, but LineageOS has a very big community, which you will have to rely on if you encounter The Ugly[^4].

Important note: your phone model is weird. Phones with the same name can have different model numbers, using a different carrier can give you a different model number (which would be relevant when flashing a radio partition for example), etc.; you need to exactly determine your phone's model number to check device compatibility. 

### Connecting a pc to a phone

You will want android debug bridge [here](https://developer.android.com/tools/releases/platform-tools) (or through your package manager) and a computer->phone usb cable. If you haven't already, enable USB debugging in your phone's developer options, and accept whatever pairing prompt comes up when you plug it in[^5]. Verify your connectivity by running `adb`[^6] in your terminal.

Now you have to get into your phone's bootloader interface. The next two bullets are two ways to do that.

- Run `adb -d reboot bootloader`[^6] in your terminal.

- Turn your phone off. Turn it on holding both the power and volume down buttons. On some old phones, this will be reversed. Some phones won't register the state of the volume down button if it's held during this entire process, and will require you to repress it once the screen turns on. You'll generally be greeted by a black screen with some jank text on it, maybe a logo if you're lucky, with a rudimentary menu navigable by the 3 buttons. You might have to navigate this menu until you encounter a state labeled `bootloader` or `fastboot`. If this screen says `recovery` and you can't navigate out of it, you're actually in the wrong boot mode! There might be no text at all[^7].

Verify that you're connected to the phone's bootloader interface on your pc by opening a terminal and running `fastboot devices`[^6].

### Flashing[^8]

You're probably gonna lose all data on your phone if we proceed. This is the scary step, too. Are you emotionally prepared for that?

Every ROM has a different MO for flashing, and you need to find your ROM's installation guide ([Lineage [device specific]](https://wiki.lineageos.org/devices/) [Graphene](https://grapheneos.org/install/web) [Copperhead](https://copperhead.co/android/docs/install/)). Some might use first-party tools like samsung Odin, many (including Lineage) specifically flash the recovery partition and then `adb sideload` a `.zip` for the recovery partition to use. The problem is that there are many different partitions you might have to flash, and any mistake has big consequences:
- `system` stores our ROM. A bad flash here will probably boot-loop your phone, nothing serious.
- `radio` is our modem, and some ROMs will want to flash that partition. I suspect your kernel would be upset with a bad radio partition
- `recovery` is the partition that helps you rebuild your phone when it breaks; some roms will flash it. Breaking this doesn't matter much because you can recover from your pc (via `fastboot flash`). I reflash my recovery all the time. I highly recommend [TWRP](https://twrp.me/Devices/), though you should clarify the version you want to flash plays well with your ROM.
- Some will flash `bootloader`, the partition your phone is booted into right now. ***`A bad bootloader flash is how you brick a phone.`*** This is because the bootloader can flash all other partitions.
- `kernel` usually has its own partition, but a popular ROM isn't usually going to require a custom linux kernel. A bad kernel won't brick your phone, but you'll probably boot-loop or crash frequently.

Pretty much every ROM installation goes like this:
- OEM unlocking and USB debugging (as root if the toggle is available) need to be enabled as per the `OEM Unlocking` section above
- `fastboot flashing unlock` is another safeguard, and iirc the phone data wipe.
- `fastboot flash <partition> <uncompressed file>` flashes a specific partition. Most ROMs will bundle this in a script of some kind, for aforementioned "don't brick your phone" reasons. After flashing a few partitions in your guide, you'll be done.
- after the flashing is done, you should `fastboot flashing lock` your bootloader, then disable OEM unlocking from developer options.

So why all the disclaimers? It's very easy to get the wrong firmware (things-to-flash) for your phone. My Pixel 5 has the single `redfin` release, which is nice and easy to remember. There are 15 different model numbers for my LG V20, some of which overlap, and some of which don't. Flashing `LG V20 H918` instead of `LG V20 H915` firmware could potentially brick a phone, and this kind of thing is a nightmare for tech support to handle.


### Magisk

You can get Magisk [here](https://github.com/topjohnwu/Magisk/releases). It's a neat little program to manage which apps on your phone get root access, or more importantly, which apps can see that you have root access. It has its own little guide, typically involving sideloading, so it's best to get it done now.


[^1]: The first time I rooted my phone (a galaxy note 4 -- I miss it dearly), I installed a truly universal remote and spent the next week disabling public TVs

[^2]: FKA CyanogenMod, the oldest game in town

[^3]: AKA bootloader unlocking, NOT carrier unlocking. Carrier unlocking means you can use the phone on any carrier (but you will probably want to check band compatibility for a phone from a separate region). OEM unlocking means the Original Equipment Manufacturer can unlock your bootloader.

[^4]: I have never unrecoverably bricked a phone, or known anyone who has. I haven't personally dealt with random crashes, but I've seen them

[^5]: iirc this isn't necessary because pairing is automatically accepted in the next step, but some phones are so picky.

[^6]: For windows command prompt specifically, you'll have to find the adb executable, typically installed in `C:\Android\sdk\platform-tools\`. Press the windows key, search for `adb`, right click it and open file location to check. Then navigate to it in command prompt using `cd C:\path\to\adb\executable\parent\folder`, THEN you can run adb/fastboot commands.

[^7]: One time, I opened this menu, and was greeted with a glitched noise texture reminiscent of GPU failure. It still worked, though. Thankfully LG doesn't make phones anymore

[^8]: Overwriting. The etymology is kindof fun. On most computers (and some phones), flash memory refers to a tiny standalone ssd, like a usb drive. Fast compared to hdds, and you write to it with bursts of relatively high voltage, hence "flashing". Nowadays we use the same tech for ssds, nand flash memory.