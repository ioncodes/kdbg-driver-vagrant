# kdbg-driver-vagrant

_Based off of [this](https://secret.club/2020/04/10/kernel_debugging_in_seconds.html) article_

[my gist](https://gist.github.com/ioncodes/2383d35fe7ddf8d52333f7cb0b1e6a85)

**My current set up uses a slightly different approach which is described [here](fast/).**

## Setup

1. Install the [VMWare Vagrant Utility](https://www.vagrantup.com/vmware/downloads). Reboot your machine afterwards.
2. Set up a Windows 10 VM as you normally would. Keep the hardware requirements (CPU and RAM) to a minimum.
3. In the VM:
   1. Install the VMWare guest tools
   2. Disable Shutdown Tracker
   3. Disable complex passwords
   4. Set network adapter to "Private"
   5. Enable RDP
   6. Disable Driver Signature Enforcement and enable Test Sign mode
   7. *Completely* disable UAC: In `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System` set `EnabledLUA` to 0
   8. Install all pending updates (optional)
   9. To redirect debug messages to WinDbg (optional): In `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager` create the key `Debug Print Filter`. Add a DWORD entry called `DEFAULT` with value 0xFFFFFFFF
4. Shutdown VM
5. Open the "Virtual Network Editor" and hit "Change Settings". Select NAT in the list and then NAT Settings. Set UDP timeout to 32767 or WinDbg may get disconnected
6. Go to the folder containing the vmx file
7. Execute `tar cvzf Win10ProBase.box ./*`. This is the equivalent of running `vagrant package` for VBox.
8. If step 7 fails create a file called `metadata.json` in that directory with the following content:
   ```json
   {
    "provider": "vmware_desktop"
   }
   ```
8. Execute `vagrant box add layle/win10pro .\Win10ProBase.box`
9. You are all set now. Use the attached files to spin up your boxes

Make sure to update the host IP in the batch files to your own host IP!
