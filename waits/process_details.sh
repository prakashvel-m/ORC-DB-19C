--Check the CPU usage of lms process (per core)
ps -eo pid,ppid,cmd,pri,ni,cls,rtprio,%mem,%cpu --sort=-%cpu | grep lms
