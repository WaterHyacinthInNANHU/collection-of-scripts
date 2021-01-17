listening_port="1233"
master_port="6666"
master_sync_port="6665"
data_path="data.txt"
master_path="master.txt"

echo "SLAVE: slave.bash"
echo "This script is used to trigger the recording of csi and synchronize data.txt"
inetip=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
echo "inet ip of this device: ${inetip}"
echo "listening at port ${listening_port}"

while true
do
    text=$(nc -l $listening_port)
    if [ ! -z "${text}" ]; then
        if [ "${text}" = "_trigger_" ]; then
            while [ ! -z "$(lsof ${data_path})" ]; do sleep 0.1; done
            para1=$(awk NR==2 ${data_path})
            # para2=$(awk NR==3 ${data_path})
            # para3=$(awk NR==4 ${data_path})
            echo "recording csi..."
            # execute csi recording here
            echo -e "done\n"
            while [ ! -z "$(lsof ${master_path})" ]; do sleep 0.1; done
            master_ip=$(awk NR==1 ${master_path})
            master="${master_ip} ${master_port}"
            echo "[${inetip}]: done" | nc $master -w 0
        else
            # synchronize data.txt
            while [ ! -z "$(lsof ${data_path})" ]; do sleep 0.1; done
            if [ "${text}" = "_clear_" ]; then
                > $data_path
                echo "data has been cleared!"
            else
                echo "$text" > $data_path
                # echo "write succeed!"
                echo "${data_path}:"
                echo "############################"
                cat $data_path
                echo -e "############################\n"
            fi
            # echo master
            while [ ! -z "$(lsof ${master_path})" ]; do sleep 0.1; done
            master_ip=$(awk NR==1 ${master_path})
            master="${master_ip} ${master_sync_port}"
            echo "_synchronized_" | nc $master -w 0
        fi
    fi
done