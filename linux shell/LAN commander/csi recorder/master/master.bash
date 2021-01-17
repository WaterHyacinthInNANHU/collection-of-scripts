slave_port="1233"
listening_message_port="6666"
listening_sync_port="6665"
data_path="data.txt"
aoa_profile_path="./nlink_unpack/csi_name.txt"
slaves_path="slaves.txt"

echo "MASTER: master.bash"
echo "This script is used to command slave"
inetip=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
echo "inet ip of this device: ${inetip}"
echo "listening at port ${listening_sync_port} and ${listening_message_port}"

while true
do

    read -n 1 -p "press 'y' to record: " asw
    echo ""
    if ! [ "${asw}" = "y" ]; then
        continue
    fi

    echo -e "\n"

    # execute aoa
    echo "execute aoa..."
    sudo ~/nlink_unpack/nlink_unpack
    echo -e "done\n"

    # record aoa information into data.txt
    while [ ! -z "$(lsof ${aoa_profile_path})" ]; do sleep 0.1; done
    data_csi_name=$(awk NR==1 ${aoa_profile_path})
    sed -i "1c\\${data_csi_name}" $data_path

    # synchronize data.txt
    echo "synchronize data..."
    while [ ! -z "$(lsof ${data_path})" ]; do sleep 0.1; done
    data=$(cat ${data_path})
    num=1
    while true
    do
        while [ ! -z "$(lsof ${slaves_path})" ]; do sleep 0.1; done
        slave_ip=$(awk NR==${num} ${slaves_path})
        if [ -z "${slave_ip}" ]; then
            break
        fi
        echo "sychronizing ${slave_ip}..."
        slave="${slave_ip} ${slave_port}"
        if [ ! -z "${data}" ]; then
            echo "${data}" | nc $slave -w 0
        else
            echo "_clear_" | nc $slave -w 0
        fi
        # wait for response from slave
        text=$(nc -l $listening_sync_port)
        if [ "${text}" = "_synchronized_" ]; then
            num=$num+1
        else
            continue
        fi
    done
    echo -e "done\n"

    # trigger csi recording
    echo "trigger csi recording on slave..."
    num=1
    while true
    do
        while [ ! -z "$(lsof ${slaves_path})" ]; do sleep 0.1; done
        slave_ip=$(awk NR==${num} ${slaves_path})
        if [ -z "${slave_ip}" ]; then
            break
        fi
        echo "triggering ${slave_ip}..."
        slave="${slave_ip} ${slave_port}"
        echo "_trigger_" | nc $slave -w 0
        num=$(( $num + 1 ))
    done
    echo -e "done\n"

    # listen to message
    echo "listening to result returned by slaves..."
    while ! [ "${num}" = "1" ]
    do
        message=$(nc -l $listening_message_port)
        if [ ! -z "$message" ]; then
            echo $message
        fi        
        num=$(( $num - 1 ))
    done
    echo -e "done\n"

done
