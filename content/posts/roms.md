---
title: "roms"
date: 2024-03-19T13:52:11-07:00
draft: false
---

This is a step-by-step educational guide to accompany a custom rom installation guide for your android phone.

Intermediate difficulty; we'll be using a terminal (powershell[^6] on windows). You'll have to retrieve some information about your phone and your desired rom that I can't easily help you get. If you're stuck, bring your phone to open hack night so we can fix it.

### Pros/Cons of customizing android

The Good:
- debloating (cannot overemphasize this, especially wrt battery life)
- degoogling
- extending your phone's end-of-life
- [free hotspotting](https://quatl.ooo/posts/hotspot/) and other miscellaneous perks
- the smug, immaculate vibes of a post-adversarial user-OS relationship

The Bad:
- sometimes voiding your warranty
- the people who thanklessly maintain your rom
- degoogling

The Ugly:
- bricking your phone
- boot-looping your phone
- debugging random crashes, freezes, etc

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/boot-loops.jpg)

### What's rooting/Should I stay rooted?

Phone manufacturers don't easily give you full (root) access to your phone. You can break things easily, it's a security nightmare[^10], and you can remove their data collection/bloatware. If you ask nicely, or sometimes force your way in, you can edit your operating system via your device firmware[^11].

After patching together our edited OS, we must decide whether to expose root access to our apps/our self.

Reasons to stay rooted:
- root-only package managers and apps
    - [xposed modules](https://xdaforums.com/f/xposed-framework-modules.2919/)
    - actually usable android file managers
- unlocking vestigial hardware features on some old phones
    - FM/AM radio
    - Fun With IR[^1]
- very hackable

Reasons to not stay rooted:
- the perpetual cat-and-mouse game of root detection and Magisk[^13]
- larger attack surface[^10]

### Choosing a rom

Some secure roms aren't intended to be rooted. For reasons[^12], these are almost exclusively made for Pixel phones. If you have a Pixel, you can choose between [GrapheneOS](https://grapheneos.org/install/) (my choice), [Copperhead](https://copperhead.co/android/docs/), or [CalyxOS](https://calyxos.org/docs/guide/device-support/) (has some motorola/fairphone support!).

Otherwise, you want [Lineage](https://wiki.lineageos.org/devices/)[^2], maybe [crDroid](https://crdroid.net/downloads) or something else [listed here](https://en.wikipedia.org/wiki/List_of_custom_Android_distributions) that is both open source and still developed. Another option might be decent; I haven't reviewed them in awhile, but LineageOS has a very big community, which you will have to rely on if you encounter The Ugly[^4].

### Bootloader Unlocking[^3]

If you didn't buy a phone specifically for this, this might become much more annoying/"impossible" based on these results:

- Go to settings -> About phone
- Tap the build number button like 8 times (I'm not trolling you) to unlock developer options
- Go to developer options (under `system` settings) and see if there's an `OEM unlocking` toggle.
- While you're here, enable USB debugging

If `OEM Unlocking` is greyed-out, you might have to get an unlock code from your phone manufacturer and insert it via `fastboot` (this is as annoying as it sounds). Otherwise, you probably can't proceed. Go to [xda-developers](https://xda-developers.com), find your phone subforum, and see if anyone has posted about rooting it. In ye olden days (a decade ago, when I first started rooting my phones), you typically had to use some privilege-escalation linux kernel vulnerability to unlock a bootloader. Good luck!

### Connecting a pc to a phone

Get [android debug bridge](https://developer.android.com/tools/releases/platform-tools) (or via package manager) and a computer->phone usb cable. If you haven't already, enable USB debugging in `developer options`, and accept whatever pairing prompt comes up when you plug it in[^5]. Verify your connectivity by running `adb devices` in your terminal.

### Getting your exact model

Phones with the same name can have different model numbers. You should exactly determine your phone's model number. `settings` -> `about phone`, look for `model number` or `regulatory labels` or similar. My Pixel 5 has model `GD1YQ`.[^15] 

### Accessing your phone's bootloader interface

You can either do this from your pc or from your phone:

- PC: Run `adb -d reboot bootloader` in your terminal.

- Phone: Turn your phone off. Turn it on holding both the power and volume down buttons. On some old phones, this will be reversed. Some phones won't register the state of the volume down button if it's held during this entire process, and will require you to repress it once the screen turns on. You'll generally be greeted by a black screen with some jank text on it, maybe a logo if you're lucky, with a rudimentary menu navigable by the 3 buttons. You might have to navigate this menu until you encounter a state labeled `bootloader` or `fastboot`. If this screen says `recovery` and you can't navigate out of it, you're actually in the wrong boot mode! There might be no text at all[^7].

Verify that you're connected to the phone's bootloader interface on your pc by opening a terminal and running `fastboot devices`.

### Flashing[^8]

You'll lose all data on your phone if we proceed. This is the scary step, too. Are you emotionally prepared for that?

Every rom has a different MO for flashing, and you need to find your rom's installation guide ([Lineage [device specific]](https://wiki.lineageos.org/devices/) [Graphene](https://grapheneos.org/install/web) [Copperhead](https://copperhead.co/android/docs/install/)). Some might use first-party tools like samsung Odin, many (including Lineage) specifically flash the recovery partition and then `adb sideload` a `.zip` for the recovery partition to use. The problem is that there are many different partitions you might have to flash or wipe:
- Some will flash `boot`, the partition your phone is booted into right now. ***`A bad bootloader flash is how you brick a phone.`***; the bootloader can rescue all other partitions (via `fastboot flash`).
- `system` stores most of what constitutes our rom. A bad flash here will probably boot-loop your phone
- `data` stores our user data; installed apps, settings, etc.
- `cache`[^14] can be wiped safely
- `radio`: some roms will want to flash it.
- `recovery` is the partition that helps you rebuild your phone when it breaks; most roms will flash it. I highly recommend [TWRP](https://twrp.me/Devices/), though you should check version compatibility with your rom (and don't use it with the secure Pixel roms).
- `kernel`: user-friendly roms aren't usually going to require a custom linux kernel. The wrong kernel won't brick your phone, but you'll probably boot-loop or crash frequently.

You can backup a partition[^17] using `dd`, e.g. `adb shell su -c dd if=/dev/path/to/<partition> > <partition>.img` to your pc.

Pretty much every ROM installation goes like this:
- OEM unlocking and USB debugging (as root if the toggle is available) need to be enabled as per the `OEM Unlocking` section above
- `fastboot flashing unlock` is another safeguard, and ***`also the data partition wipe`***.
- `fastboot flash <partition> <uncompressed file>` flashes a specific partition. Most ROMs will bundle this in a script of some kind, for aforementioned "don't brick your phone" reasons. After flashing a few partitions in your guide, you'll be done.

So why all the disclaimers? It's very easy to get the wrong firmware (things-to-flash) for your phone. There are 15 different model numbers for my LG V20, only some of which overlap all firmware. Blindly flashing `LG V20 H918` firmware instead of `LG V20 H915` could brick, and you wouldn't be able to tell without checking.

### Re-lock your bootloader?

Once you re-lock your bootloader in fastboot, unlocking it again will wipe your phone. In the interrim, you can decide whether or not to expose root to yourself and your apps by installing Magisk.

Again, if you're using one of the secure Pixel roms, you don't want to keep root, and usually they won't let you anyway.

### Magisk

You can get Magisk [here](https://github.com/topjohnwu/Magisk/releases). It's a neat little program to manage which apps on your phone get root access, or more importantly, which apps can see that *you* have root access. It has its own [guide](https://topjohnwu.github.io/Magisk/install.html). If you don't have boot ramdisk, keeping root becomes very tedious and I personally wouldn't bother.


If you're going to flash [TWRP](https://twrp.me/Devices/) as a recovery, do it now, and try to sideload the Magisk `.apk` after renaming it to a `.zip`, to skip this next part.

The Magisk guide doesn't tell you how to get a `boot.img` copy. Getting `init_boot.img` works much the same way, just ignore the suffix syntax.
- First find out if you have `init_boot.img` by running `adb shell su -c find /dev -type f -name init_boot.img 2>/dev/null`. If you have one, `adb shell su -c dd if=<the file you just found> of=/wherever/you/want/to/dump/init_boot.img` should get you your image-to-patch.
- If you don't have `init_boot.img`, my TL;DR is `adb shell su -c dd if=/dev/block/by-name/boot$(adb shell getprop ro.boot.slot_suffix) of=/wherever/you/want/to/dump/boot.img`[^18] and has worked on every phone I've tested. An explanation:
    - Firstly, your boot image is almost always linked in `/dev/block/by-name/<boot or something>`. If it's not there, you're going to have to poke around. I would run `adb shell su -c find /dev -type f -name 'boot*' 2>/dev/null` to just search all the devices that start with `boot`.
    - Secondly, a lot of android phones these days have an A/B booting system; there are actually 2 boot images, and only one is live, and the other receives updates, and then they switch. `adb shell getprop ro.boot.slot_suffix` is the idiomatic way to determine if A or B is live (we want the live one). If that doesn't work, enter your bootloader interface again and run `fastboot getvar current-slot` (sometimes it's also just displayed in the bootloader interface UI).
- Now you can patch the image you grabbed using the Magisk app and continue with its own guide

### Re-lock your bootloader!

Go back into the bootloader interface (`adb -d reboot bootloader`) and `fastboot flashing lock` it. Then `fastboot reboot`, go to your developer options and disable OEM unlocking[^16]. Then disable developer options. Then throw your phone into a lake.


[^1]: The first time I rooted my phone (a galaxy note 4 -- I miss it dearly), I installed a truly universal remote and spent the next week disabling public TVs

[^2]: FKA CyanogenMod, the oldest game in town

[^3]: AKA bootloader unlocking, NOT carrier unlocking. Carrier unlocking means you can use the phone on any carrier (but you will probably want to check band compatibility for a phone from a separate region). OEM unlocking means the Original Equipment Manufacturer can unlock your bootloader.

[^4]: I have never unrecoverably bricked a phone, or known anyone who has. I haven't personally dealt with random crashes, but I've seen them

[^5]: iirc this isn't necessary because pairing is automatically accepted in the next step, but some phones are so picky.

[^6]: For windows command prompt specifically, you'll have to find the adb executable after installing it, typically installed in `C:\Android\sdk\platform-tools\`. Press the windows key, search for `adb`, right click it and open file location to check. Then navigate to it in command prompt using `cd C:\path\to\adb\executable\parent\folder`, THEN you can run adb/fastboot commands.

[^7]: One time, I opened this menu, and was greeted with a glitched noise texture reminiscent of GPU failure. It still worked, though. Thankfully LG doesn't make phones anymore

[^8]: Overwriting. The etymology is kindof fun. On most computers (and some phones), flash memory refers to a tiny standalone ssd, like a usb drive. Fast compared to hdds, and you write to it with bursts of relatively high voltage, hence "flashing". Nowadays we use the same tech for ssds, nand flash memory.

[^9]: Because android is based off the linux kernel, and linux filesystems represent device firmware as files under /dev, the lines between software and firmware blur

[^10]: A rogue app could go from being able to aggressively monetize you to being able to destroy your phone, among other concerns

[^11]: ROM stands for read-only memory. Device firmware used to be unwriteable after being manufactured. Now, phone roms just refers to firmware edits. Think of installing a rom like detailing the android OS; an aftermarket set of modifications.

[^12]: Google makes it easy to hack on Pixels with easy bootloader unlocking. The Pixel rom is very close to stock android, making it easier to produce. Pixels from I believe the 3 onward have additional security features from the Titan M chip: secure boot, a secure partition, hardware-based encryption, etc.

[^13]: Keeping root means giving apps access to root. However, we don't want every app to have root access, so we control who gets what. However, android will still attempt to notify apps if the user has root access. Banking apps are notorious for refusing to work if android snitches on you. So we have to play this constant game of trying to hide the fact that we have root from android, which seems impossible, but then you remember, we have complete root access. Anyway, we've been winning this game for the past few years, but it was pretty dire like 5 years ago.

[^14]: You may also encounter the `dalvik cache` or the `ART cache`. These can also generally be safely wiped. Dalvik is the old VM that apps used to run in. ART (android runtime) replaced it a long time ago, instead generating bytecode from apps to load them faster.

[^15]: I also usually sanity-check at [gsmarena](https://gsmarena.com) and search for my phone, and expand the network section like so:

[^16]: Also, change each `animation scale` to 0.5x, oh my god, it's so smooth.

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/pixel-models.png)

The Pixel 5 (redfin) has 2 submodels, `GD1YQ` and `GTT9Q`. This shows how models differ in radio firmware, exactly which carriers my phone could use via band compatibility, what region my phone actually belongs to etc., and if my rom was far from stock android, and I was flashing radio firmware...

[^17]: You aren't necessarily rooted right now. While you can overwrite existing partitions, some images don't provide root debugging. You can test by running `adb root`, or `adb shell` followed by `su`. If root debugging isn't an option in `developer options`, you could try TWRP (download the twrp img, and then boot into it with `fastboot boot <img>`). Some phone OEMs provide tools for this exact reason, and you could always disassemble the phone to directly access the chips if you reeeeally wanted the images, I guess?

[^18]: You'll probably want to dump the boot image in userspace to delete it easily later. Almost always `/storage/emulated/0/`