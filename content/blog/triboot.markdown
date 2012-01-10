---
created_at: 2010-01-10
foo: bar_
excerpt: One of the things I did over my winter holidays was to tri-boot my MacBook Pro.
kind: article
tags: [ triboot, mac, windows, ubuntu, linux ]
title: Tri-booting my MacBook Pro
---

One of the things I did over my winter holidays was to tri-boot<sup><a href="#n1" id="t1">1</a></sup> my MacBook Pro (model version 4.1, with the disc drive at the front).  I installed Windows 7 and [Ubuntu Linux 9.10 (Karmic Koala)][1ubuntu], while leaving the original Mac OS X Leopard (version 10.5) untouched.

What, you may ask, prompted me to undertake this ridiculous task? The answer is in that question -- the task was ridiculous.  I did it mostly for the sake of doing it.

However, there *were* practical reasons.

Firstly, the experience would be worthwhile.  I have in the past experimented with dual-boot Windows/Linux systems, but never had I multi-booted a Mac system, or attempted a tri-boot.  Secondly, I occasionally need to use Windows: some of my professors upload PowerPoint files with proprietary symbols and formatting, and I can't open them properly with [OpenOffice.org][1ooo].  My original workaround was to use [VirtualBox][1vb] to run Windows 7 and Microsoft Office.  It was usable, but slow.  (Not enough RAM on my Mac, I believe.)  Finally, I wanted to use Ubuntu again.  I used to run Ubuntu/Windows on a desktop, but stopped using Ubuntu once I got a MacBook Pro.

I do not plan on writing a step-by-step guide in this post.  Instead, my intention here is share the resources I used, and comment on what worked or didn't work for me (and how I got it working).

[1ubuntu]: http://www.ubuntu.com/
[1ooo]: http://www.openoffice.org/
[1vb]: http://www.virtualbox.org/


Preparation
===========

Before I started, the first thing I did was to update my system (to version 10.5.8) and back it up.  I will stress this: **before you do anything, make sure you have a good backup!** Next, I thought for a bit and planned out how I would partition my drive.

This is what I came up with:
      Device   Filesystem    Size   Use
    /dev/sda1    fat32      20 MiB  EFI partition
    /dev/sda2    hfs+      130 GiB  Mac OS X
    /dev/sda3    ext4       50 GiB  Ubuntu
    /dev/sda5    swap        2 GiB  Linux swap
    /dev/sda4    ntfs       50 GiB  Windows 7
                    Total: 232 GiB
<sup><a href="#n2" id="t2">2</a></sup>
<sup><a href="#n3" id="t3">3</a></sup>

(I decided against a "shared" partition that could be accessed by all three systems, to keep things simple.  If I want to transfer files, I just use my USB flash drive.)

Now I could get started! [This][2tripleboot] is the guide I followed.  It worked fairly well for me, except for a few issues here and there that I'll discuss.

[2tripleboot]: http://www.maganti.info/2009/11/triple-boot-on-macbook-mac-osx-1061.html


Installing and Configuring Windows 7
====================================

Installing Windows 7 was easy and straightforward, despite [Apple not officially supporting Windows 7][3apple-bc].  I followed [these][3bc-walkthrough] steps, using Boot Camp to install Windows.

Configuring Windows wasn't quite as easy, but I didn't encounter too many difficulties.  The first thing I did was to run Windows Update.  Next, I inserted my Mac OS X install DVD, to install the Boot Camp drivers.  Then I downloaded and installed [inputremapper][3inputremapper].  I didn't really care for remapping the keybindings (it was working fine for me), but I wanted some control over the fans.  (Admittedly, I haven't used Windows enough to notice a difference on my Mac.)

Now I came to two slight issues.  Sound didn't work, so I had to manually download and install [Realtek drivers][3realtek].  You'll want the High Definition Audio Codecs. (As an aside, at the time I was doing this, the Realtek server was being slow, and my download would move at 2 kB/s and time out.)  Once I got the drivers installed, sound was working perfectly.

The next problem were the video drivers.  Aero Glass wasn't working.  I know it wasn't necessary, but I liked some of the features Aero Glass offered.  I went to [NVIDIA][3nvidia] to download the GeForce 8M Series drivers.  However, installing still didn't get Aero Glass working.  I had to play around and Troubleshoot Aero Glass, which automatically fixed the problem for me.

Finally, as a matter of aesthetics, I went to the drive C's properties and changed the volume name to "Windows 7."  This ensured that when I was using Mac, the partition would be mounted as "Windows 7" and not the awkward "Untitled."

Now, this isn't really configuring Windows, but for security and protection, I installed Norton Antivirus, [Spybot - Search &amp; Destroy][3spybot-sd], and [Microsoft Security Essentials][3mse].  I also chose to use [Firefox][3firefox] and [Google Chrome][3chrome] instead of Internet Explorer.

[3apple-bc]: http://apple.slashdot.org/story/10/01/01/2247245/Apple-Fails-To-Deliver-On-Windows-7-Boot-Camp-Promise
[3bc-walkthrough]: http://www.simplehelp.net/2009/01/15/using-boot-camp-to-install-windows-7-on-your-mac-the-complete-walkthrough/
[3inputremapper]: http://www.olofsson.info/inputremapper.html
[3realtek]: http://www.realtek.com/downloads/
[3nvidia]: http://www.nvidia.com/Download/index.aspx?lang=en-us
[3spybot-sd]: http://www.safer-networking.org/en/index.html
[3mse]: http://www.microsoft.com/Security_Essentials/
[3firefox]: http://www.mozilla.com/en-US/firefox/personal.html
[3chrome]: http://www.google.com/chrome/index.html


Installing and Configuring Ubuntu
=================================

This was a bit trickier, since Linux isn't officially supported.  But after a lot of searching and research, I managed to get Ubuntu working well.

I followed the steps in the guide: repartition the drive, download [rEFIt][4refit]<sup><a href="#n4" id="t4">4</a></sup> (but don't install it yet), and install Ubuntu.  I made a note that Ubuntu was installed to `/dev/sda3` -- this is where GRUB needs to be installed.  (I believe the guide has a typo: it says to install the boot loader to `/dev/sda4`, when I think they mean `/dev/sda3`.)

Once Ubuntu was installed, I rebooted into Mac, where I installed rEFIt, which works as a nice bootloader.

Next, I followed these two pages \[[one][4one], [two][4two]\] to perform a few general tweaks and to get things going.  I also wanted to change the [Function Key behaviour][4fnkey].  By default, in Mac and Linux, pressing F10 will act as a special key (mute/unmute on my keyboard), and Fn+F10 will act as F10 normally would.  I prefer it the other way around, where F10 would work normally, and I'd have to press Fn+F10 to access the special function.

Next, I wanted to change a few GRUB settings.  Karmic Koala uses [GRUB 2][4grub], which I'm not familiar with.  The only thing I really changed was to decrease the timeout from 10 seconds to 3 seconds.  By that point, I would have already selected Ubuntu from rEFIt, so I wouldn't need a delay of 10 seconds to select Ubuntu again.

Now, this next thing was particularly irritating.  The wireless card didn't work.  I looked at a lot of sites and tried a lot of different things, and even now I'm not sure exactly what I did that made it work.  The first thing I tried was to enable the proprietary Broadcom drivers.  I also installed [wicd][4wicd] (and had to manually go into preferences and set`wlan0` as the wireless interface).  Then I followed [these][4wicd-fix] steps.

After all this, I finally got the wifi working.  (Except that now I'm back in my residence, it has mysteriously stopped working.  Interesting...  If you have any suggestions, please leave a comment.)

[4refit]: http://refit.sourceforge.net/
[4one]: http://mac.linux.be/content/karmic-koala-macbook-41
[4two]: https://help.ubuntu.com/community/MacBookPro4-1/Karmic
[4fnkey]: https://help.ubuntu.com/community/AppleKeyboard#Change%20Function%20Key%20behavior
[4grub]: https://wiki.ubuntu.com/Grub2
[4wicd]: http://wicd.sourceforge.net/
[4wicd-fix]: http://ubuntuforums.org/showthread.php?t=735846


Clean-up and Final Notes
========================

Now, with all three systems installed, there was just one thing bugging me: the rEFIt menu.  Since rEFIt didn't recognize GRUB2, it had Ubuntu as a "legacy operating system" with a bland icon instead of [Tux][5tux].  Besides that, I didn't really like the blue Apple logo they had, or the Windows XP logo.  I figured I might as well make my own icons.

I've packaged them [here][5icons].  I used a white Apple logo and the Windows Vista/7 logo.  For Linux, I didn't try to make rEFIt recognize GRUB2.  I did something simpler: I overwrote the legacy OS icons with Ubuntu icons.

Now everything works the way I want it to!

One last thing.  I had discovered that it's possible to use VirtualBox to boot and run Windows (or Ubuntu) as a virtual machine, even if the operating system had been installed to a partition as part of a multi-boot computer \[[one][5one], [two][5two], [three][5three]\]. This meant I could reboot into Windows for better performance, or stay in Mac and conveniently open Windows in a virtual machine.  Cool!

However, there were a few issues that worried me.  The process didn't seem all that reliable, and I didn't want Windows to panic whenever I switched from between using the real hardware and virtualized hardware.  (Windows XP had a feature called "Hardware Profiles" that would have helped, but it was removed in Windows Vista and not put back into Windows 7.)  In the end, I decided it wasn't worth the trouble.

But it didn't bother me too much.  Getting all three operating systems to run nicely was all I really wanted, and I already had that.

Oh, and before anyone suggests a quad-boot (or more): no, not even I'm that crazy.

[5tux]: http://en.wikipedia.org/wiki/Tux
[5icons]: http://files.mhyee.com/refit_icons.zip
[5one]: http://dashes.com/anil/2009/10/how-to-run-windows-7-under-mac-os-x-106-for-free.html
[5two]: http://forums.virtualbox.org/viewtopic.php?f=8&t=19866
[5three]: http://www.sentientmobile.com/jshaw/blog/post/2009/08/26/Running-VirtualBox-on-a-Windows-Vista-bootcamp-partition-in-Mac-OS-X.aspx


Notes
-----

 1. <a style="text-decoration: none;" id="n1" href="#t1">^</a> I've seen both "triple-boot" and "tri-boot," but I am making an effort to use "tri-boot" so it parallels the usages of "dual-boot," "dual-core," "quad-boot," and so on.  Google shows that terms like "double-boot" and "quadruple-boot" exist, but I personally haven't encountered those terms anywhere else.<br/><br/>
I don't think there is a "correct" way, so I'll just stick to the one I like.  (In my googling, I found a Wikipedia article on [numerical prefixes][nprefix] -- it seems that *cardinal Latin prefixes* are what I want.  Except that "dual" and "quad" are not prefixes, but "tri-" is.  So even my attempt at consistency is inconsistent!)

 2. <a style="text-decoration: none;" id="n2" href="#t2">^</a> There appears to be a "hidden" 20 MiB partition at the very beginning of the desk, used as an EFI system partition.  According to [rEFIt][nrefit], not only is this "hidden EFI System Partition" unnecessary, but it's also *empty*!  I decided not to risk it, though.

 3. <a style="text-decoration: none;" id="n3" href="#t3">^</a> There's a lot of inconsistency surrounding [*kilobyte* and *kibibyte*][nxkcd].  Kilobyte (abbreviation kB) technically means "1000 bytes," since *kilo-* is the [SI prefix][nsi_prefix] for "one thousand."  However, kibibyte (abbreviation KiB) means "*1024* bytes," with *kibi-* being the [IEC][niec] prefix for "kilobinary."  This difference (1000 vs 1024) arises from the fact that 10<sup>3</sup> = 1000, while this is approximated in binary with 2<sup>10</sup> = 1024.<br/><br/>
In this case, my laptop's hard drive was advertised as having "250 GB."  This is true: *giga-* is 1000<sup>3</sup> -- a billion -- and my drive does have 250 billion bytes.  However, the operating system only reports it having around 232 GB.  Where did the 18 gigabytes go?  Nowhere, it transpires.  My computer is also correct -- in a sense.  If you take 250 x 1000<sup>3</sup> bytes and divide by 1024<sup>3</sup> (a gibibyte -- a billion binary bytes), you get 232.8.  So *technically* my drive has a capacity of 232.8 gibibytes (GiB).  But gibibyte and its related units never caught on, and gigabyte (GB) is usually used to mean *both* 1000<sup>3</sup> and 1024<sup>3</sup> bytes.  Confusing!

 4. <a style="text-decoration: none;" id="n4" href="#t4">^</a> From what I've found, it's possible to do this [without using Boot Camp <i>or</i> rEFIt][nbc].  But the instructions weren't as detailed, and I didn't have any need or desire to avoid the two.

[nprefix]: http://en.wikipedia.org/wiki/Number_prefix
[nrefit]: http://refit.sourceforge.net/myths/
[nxkcd]: http://xkcd.com/394/
[nsi_prefix]: http://en.wikipedia.org/wiki/SI_prefix
[niec]: http://en.wikipedia.org/wiki/International_Electrotechnical_Commission
[nbc]: http://ubuntuforums.org/showthread.php?t=1303459
