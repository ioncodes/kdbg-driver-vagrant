# kdbg-driver-vagrant

_Based off of [this](https://secret.club/2020/04/10/kernel_debugging_in_seconds.html) article._

## Setup

1. Install the [VMware Vagrant Utility](https://www.vagrantup.com/vmware/downloads). Reboot your machine afterwards.
2. Set up a Windows 10 VM as you normally would (ideally licensing the VM as well). Keep the hardware requirements (CPU, RAM and disk space) to a minimum.
3. In the VM:
   1. Install the VMware guest tools
   2. [Disable Shutdown Tracker](https://docs.microsoft.com/en-us/troubleshoot/windows-server/application-management/description-shutdown-event-tracker)
   3. [Disable complex passwords](https://social.technet.microsoft.com/Forums/windowsserver/en-US/a1123821-0725-440b-aaf5-836dbc38ec0f/how-complex-password-can-be-disabled?forum=winservergen)
   4. Set network adapter to "Private"
   5. [Enable RDP](https://pureinfotech.com/enable-remote-desktop-windows-10/)
   6. Disable integrity checks and enable test signing
      ```batch
      bcdedit /set testsigning on
      bcdedit /set nointegritychecks on
      ```
   7. *Completely* disable UAC
      ```
      HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System > EnabledLUA = 0
      ```
   8. Enable WinRM
      ```batch
      winrm quickconfig -q
      winrm set winrm/config/winrs @{MaxMemoryPerShellMB="512"}
      winrm set winrm/config @{MaxTimeoutms="1800000"}
      winrm set winrm/config/service @{AllowUnencrypted="true"}
      winrm set winrm/config/service/auth @{Basic="true"}
      sc config WinRM start= auto
      ```
   9. Enable kernel debugging. Make sure to replace the host IP with the IP of your host (must be reachable from within the VM)
      ```batch
      bcdedit /debug on
      bcdedit /dbgsettings net hostip:192.168.229.1 port:53390 key:1.1.1.1
      ```
   10. Install all pending updates (optional)
   11. To redirect debug messages to WinDbg (optional)
       ```
       HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Debug Print Filter > DEFAULT = 0xFFFFFFFF
       ```
       Create the key `Debug Print Filter` if it doesn't exist
4. Shutdown the VM
5. Open the "Virtual Network Editor" and hit "Change Settings". Select NAT in the list and then "NAT Settings". Set UDP timeout to 32767 or WinDbg may get disconnected (this setting persists across all VMs)
6. Go to the folder containing the `.vmx` file
7. Create a file called `metadata.json`
   ```json
   {
     "provider": "vmware_desktop"
   }
   ```
8. Execute `tar cvzf Win10ProKdbgDriverBase.box ./*`. This is the equivalent of running `vagrant package` for VBox.
9. Execute `vagrant box add layle/win10pro-kdbg-driver .\Win10ProKdbgDriverBase.box`

You are now all set to spin up boxes. To get started use `start-vm.bat` and as soon as you want to attach a debugger execute `start-debugger.bat`. Note that the VM will automatically shutdown as soon as you close WinDbg.  
In this example the driver is always called `layle.sys`. Make sure that file exists in this projects root folder (where Vagrantfile is located). Vagrant automatically mounts the Vagrant project folder to `C:\vagrant` which is required to copy the driver to `C:\Windows\System32\drivers`.