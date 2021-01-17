# LANcommander(for csi recording)

## Install

### **master**

- Copy ```master``` folder to master device
- Copy binary executable ```nlink_unpack``` to ```master\nlink_unpack\```
- Write slaves' ip addresses in ```slaves.txt```. ONE IP PER LINE, NO EMPTY LINE

### **slaves**

- Write slaves' ip addresses in ```master.txt```. 
- Copy ```slave``` folder with the modified ```master.txt``` to each slave device

## Usage

### **master**

- run ```master.bash```

### **slaves**

- run ```slave.bash```

## Workflow

![csi_recorder](csi_recorder.svg)

## Note

- If ```master.bash``` stucks with echo:

```
listening to result returned by slaves...
```

That means one or more of slave devices have not finished recording. Please either wait or check out the slaves. After that you may need to rerun ```slave.bash``` on that device and ```master.txt``` on master device.