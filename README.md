Scripts to install chrubuntu for tegra chromebook such as Acer Chromebook 13

Based on work of arm000 found [here](http://www.reddit.com/r/chrubuntu/comments/2hhb31/chrubuntu_on_acer_chromebook_13/)

Updated for latest ChromeOS on the Acer (parted and partprobe are no longer installed by default).  Also added workaround for missing whoopsie init script.  Use the script arguments to specify "flavor" "version" and device to install to an external medium such as SDCard (note the device is the third argument).

You can find some info on the chrubuntu script arguments [here](http://chromeos-cr48.blogspot.com/2013/05/chrubuntu-one-script-to-rule-them-all_31.html)

Note: if your chromebook has had time to update itself, you probably won't have the parted commands, so *before* you run the chrubuntu script on your chromebook you must make a GPT partition table on the SDCard first (see below).

What works:

                    "flavor"             "version"     "device"
                    default              latest        /dev/mmcblk1

What doesn't work:

                    ubuntu-standard      latest        -

Since the script specifically pulls in the Nvidia graphics packages for X11 and OpenGL, the ubuntu-standard flavor (which should be console only) dorks up due to missing X paths.  If you need console only, you can do Gentoo or the manual debootstrap method instead.

To install xubuntu to SDCard:

1. Put your chromebook into developer mode as described [here](http://www.chromium.org/chromium-os/developer-information-for-chrome-os-devices) (for example, the Samsung ARM chromebook).

2. On another Linux machine, install parted and insert your SDCard, then run the following commands, where target_disk is either /dev/sdX or /dev/mmcblkX:


                    $ export target_disk="/dev/mmcblk1"
                    $ sudo parted --script ${target_disk} "mktable gpt"

3. Boot the chromebook, login, and insert the SDCard.  Open a terminal with Ctl-Alt-T and at the crosh prompt type "shell" (without the quotes) and hit Enter.

4. In another tab, browse to the raw script file on github [here](https://github.com/sarnold/chrubuntu-tegra/blob/master/chrubuntu-tegra.sh) and click Raw, then right-click on the page and select Save as...  Remove the ".txt" extension and click Save.

5. Back in your terminal, type the following commands and follow the prompts:


                    $ cd /tmp
                    $ cp ~/Downloads/chrubuntu-tegra.sh .
                    $ sudo bash chrubuntu-tegra.sh default latest /dev/mmcblk1

Note: make sure you use the right device; the script can also repartition the internal SSD and install along-side ChromeOS and should do the right thing.  Just make sure it's what you want...

Now you get to have a cup (or two) of your favorite beverage, watch a movie, play some baseball, go to Tokyo, whatever.  When it's finished, it will prompt you to reboot.

Post-install workarounds:

First boot will most likely stop at a console prompt due to conflicting libglx.so plugins.  Also, the default wireless device shows up twice (as two different devices with the same MAC address) and NetworkManager will see both.  This will cause X to freeze if both get started (at least if the weird interface starts before mlan0).  The workaround I did was to modify NetworkManager.conf so it looks like this:

                    [main]
                    plugins=ifupdown,keyfile
                    dns=dnsmasq
                    
                    [ifupdown]
                    managed=false
                    
                    [keyfile]
                    unmanaged-devices=interface-name:uap0

It may also help to have a USB ethernet dongle handy, but you could also switch to wicd if NetworkManager is stubborn. Now find the extra copy of libglx.so and move it out of the way:

                    $ find /usr/lib -name libglx.so
                    $ mv /usr/lib/xorg/modules/extensions/libglx.so /usr/lib/xorg/modules/extensions/libglx.so.orig

Note: In the nm-applet GUI, the weird interface has no name, but you can see it with ifconfig.

With the above changes and a reboot, you should be greeted by the xubuntu login.  As mentioned in the script output, login as user (password: user) and then change all your passwords, add a user for yourself, etc.  Lastly, you need to uninstall one of the screensaver packages (xscreensaver is pretty old) and install zram-config, which will give you a reasonable amount of (fast) RAM-based swap.  Even without the swapfile bug in util-linux I would still recommend zram (which is chock full'o'kernel magic ;)
