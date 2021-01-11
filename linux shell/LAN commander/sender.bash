echo "This script is used to send message to 192.168.123.100:1234"
while true
do
#set following line with the slave's ip
nc 192.168.123.100 1234 -q 0
done