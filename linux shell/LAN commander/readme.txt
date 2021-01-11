These scripts are used to command multipul linux devices under the same LAN.

## Setup:
Copy receiver.bash, sender.bash to the master device.
Copy as many sender.bash as the slave devices you want to control and modify inet ip address setted in them.
Copy clinet.bash to each of slave devices, modify the comment line with your own operations.

## Usage:
Run client.bash on each of slave devices.
Run one receiver.bash and serval sender.bash on master device.
Type your command and enter to send them with sender.bash's window, execute result will be returned and shown on receiver.bash's window.


