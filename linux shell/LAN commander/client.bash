echo "This script is used to receive command from port 1234, execute program, send the result to the master"
ip=$(ifconfig | grep 'inet addr:' | grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')
echo "inet ip of this device: ${ip}"
while true
do
message=$(nc -l 1234 -w 0)
if [ ! -z "$message" ]
then
echo "your message is: ${message}"
echo "running program"
#run your operations here, message sent by master has been stored in $message
echo "${ip}: ${?}" | nc 192.168.123.221 1234
echo "waiting for command..."
fi
done
