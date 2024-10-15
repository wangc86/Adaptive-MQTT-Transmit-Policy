import random
import matplotlib.pyplot as plt
import numpy as np

sending_period = 5
timer = 20

# query message = 10KB; large message = 1MB
            # We use RTT/2 times 10 according to the benchmark result of 10KB vs. 1MB payload
            #transmission_time = ((cond[i]/2.0*10.0)+1.0/(100.0/8.0)) # 100 Mbps NIC and 1MB payload
cond = np.loadtxt("trace.dat", delimiter=",")

def latency_calculator(threshold, monitor_period, approach):
    packets = []
    for i in range(monitor_period, 5000, sending_period):  # note: the actual sending time of the last few messages may be higher than 5000; therefore, the length of cond needs to be larger than 5000+timer
        rtt_index = i - (i % monitor_period) - 1    
        last_rtt = cond[rtt_index]  # latest info obtained from monitor
        transmission_time = 0
        sojourn_time = 0
        first = True

        if approach == 1: # no withholding; baseline approach
            transmission_time = ((cond[i]/2.0*10.0)+1.0/(100.0/8.0))
            packets.append(transmission_time)
        elif approach == 2: # an optimal algorithm
            latency = ((cond[i]/2.0*10.0)+1.0/(100.0/8.0))
            j = 1
            while j <= int(latency):
                peek = j + ((cond[i+j]/2.0*10.0)+1.0/(100.0/8.0)) 
                if peek < latency:
                    latency = peek
                j += 1
            packets.append(latency)
        elif approach == 3: # conservative policy
            t = monitor_period - (i % monitor_period) # account for the first un-alignment
            while last_rtt > threshold:  # withhold
                if sojourn_time > timer:
                    break
                sojourn_time += t
                rtt_index += t
                t = monitor_period
                last_rtt = cond[rtt_index]
            transmission_time = ((cond[i+sojourn_time]/2.0*10.0)+1.0/(100.0/8.0))
            packets.append(sojourn_time + transmission_time)
        elif approach == 4: # probabilistic good
           # NOTE: need to first compare last_rtt with threshold to decide if we need to withhold at all
            if last_rtt <= threshold:
                transmission_time = ((cond[i]/2.0*10.0)+1.0/(100.0/8.0))
                packets.append(transmission_time)
            else: 
                t = monitor_period - (i % monitor_period) # account for the first un-alignment
                p = np.exp(1)**((-0.057)*t) # 0.057 = 1/17.5 where 17.5 is average congestion duration
                while last_rtt*5 > ((1-p)*threshold*5 + (p)*last_rtt*5) + monitor_period:  # withhold
                    if sojourn_time > timer:
                        break
                    sojourn_time += t
                    rtt_index += t
                    t = monitor_period
                    last_rtt = cond[rtt_index]
                    p = np.exp(1)**((-0.057)*(sojourn_time+monitor_period))
                transmission_time = ((cond[i+sojourn_time]/2.0*10.0)+1.0/(100.0/8.0))
                packets.append(sojourn_time + transmission_time)
        elif approach == 5: # probabilistic bad
           # NOTE: need to first compare last_rtt with threshold to decide if we need to withhold at all
            if last_rtt <= threshold:
                transmission_time = ((cond[i]/2.0*10.0)+1.0/(100.0/8.0))
                packets.append(transmission_time)
            else: 
                t = monitor_period - (i % monitor_period) # account for the first un-alignment
                p = np.exp(1)**((-0.016)*t) # 0.016 = 1/60 where 60 is average congestion duration
                while last_rtt*5 > ((1-p)*threshold*5 + (p)*last_rtt*5) + monitor_period:  # withhold
                    if sojourn_time > timer:
                        break
                    sojourn_time += t
                    rtt_index += t
                    t = monitor_period
                    last_rtt = cond[rtt_index]
                    p = np.exp(1)**((-0.016)*(sojourn_time+monitor_period))
                transmission_time = ((cond[i+sojourn_time]/2.0*10.0)+1.0/(100.0/8.0))
                packets.append(sojourn_time + transmission_time)
        elif approach == 6: # historic policy
           # NOTE: need to first compare last_rtt with threshold to decide if we need to withhold at all
            if last_rtt <= threshold:
                transmission_time = ((cond[i]/2.0*10.0)+1.0/(100.0/8.0))
                packets.append(transmission_time)
            else: 
                t = monitor_period - (i % monitor_period) # account for the first un-alignment
                while last_rtt*5 > threshold*5 + sojourn_time + monitor_period: # withhold
                    sojourn_time += t
                    rtt_index += t
                    t = monitor_period
                    last_rtt = cond[rtt_index]
                transmission_time = ((cond[i+sojourn_time]/2.0*10.0)+1.0/(100.0/8.0))
                packets.append(sojourn_time + transmission_time)

    return packets

def main():


#    threshold = np.arange(0.2, 0.73, 0.1)
    threshold = np.arange(0.3, 0.73, 0.1)
#    mini_values = np.arange(0.02, 0.1, 0.02)
#    threshold = np.concatenate((mini_values,threshold)) # threshold設定範圍0.02-0.7
    con_timer_long = [] # 95% confidence interval
    avg_timer_long = []
    con_timer_mid = [] 
    avg_timer_mid = []
    con_timer_short = [] 
    avg_timer_short = []
    con_timer_tiny = [] 
    avg_timer_tiny = []

#    for i in threshold:
#        long = latency_calculator(i,3) 
#        avg_timer_long.append(np.mean(long)) 
#        con_timer_long.append(1.96 * np.std(long, ddof=1) / np.sqrt(len(long)))
#
#        mid = latency_calculator(i,2) 
#        avg_timer_mid.append(np.mean(mid)) 
#        con_timer_mid.append(1.96 * np.std(mid, ddof=1) / np.sqrt(len(mid)))
#
#        short = latency_calculator(i,1) 
#        avg_timer_short.append(np.mean(short)) 
#        con_timer_short.append(1.96 * np.std(short, ddof=1) / np.sqrt(len(short)))


    avg_conservative = []
    con_conservative = []
    avg_prob_good = []
    con_prob_good = []
    avg_prob_bad = []
    con_prob_bad = []
    avg_hist = []
    con_hist = []
    for i in threshold:
        res = latency_calculator(i,1,3) 
        avg_conservative.append(np.mean(res)) 
        con_conservative.append(1.96 * np.std(res, ddof=1) / np.sqrt(len(res)))

        res = latency_calculator(i,1,4) 
        avg_prob_good.append(np.mean(res)) 
        con_prob_good.append(1.96 * np.std(res, ddof=1) / np.sqrt(len(res)))

        res = latency_calculator(i,1,5) 
        avg_prob_bad.append(np.mean(res)) 
        con_prob_bad.append(1.96 * np.std(res, ddof=1) / np.sqrt(len(res)))

        res = latency_calculator(i,1,6) 
        avg_hist.append(np.mean(res)) 
        con_hist.append(1.96 * np.std(res, ddof=1) / np.sqrt(len(res)))


    base = latency_calculator(0,1,1) 
    avg_baseline = np.mean(base) 
    con_baseline = 1.96 * np.std(base, ddof=1) / np.sqrt(len(base))

    opt = latency_calculator(0,1,2) 
    avg_opt = np.mean(opt) 
    con_opt = 1.96 * np.std(opt, ddof=1) / np.sqrt(len(opt))

    x = np.linspace(0.3,0.7,3) # 3 sample points within [0.1,0.7]
#    x = np.linspace(0.2,0.7,3) # 3 sample points within [0.1,0.7]
    y = [avg_baseline, avg_baseline, avg_baseline]
    plt.fill_between(x, y - con_baseline, y + con_baseline, color='0.9')#, alpha=0.2)
    plt.plot(x, y, '--', color='k', label='no withholding', lw=0.6)

    y = [avg_opt, avg_opt, avg_opt]
    plt.fill_between(x, y - con_opt, y + con_opt, color='r', alpha=0.2)
    plt.plot(x, y, '-.', color='r', label='clairvoyant withholding', lw=0.6)


    plt.plot(threshold, avg_conservative, linestyle='-', color='#fd8d14', label='conservative', marker='o', markersize=6)  # green
    plt.errorbar(threshold, avg_conservative, yerr=con_conservative, capsize=2, markersize=5, color='#fd8d14')   # green

    plt.plot(threshold, avg_prob_good, linestyle='-', color='#c51605', label='probabilistic (good)', marker='*', markersize=9)  # orange
    plt.errorbar(threshold, avg_prob_good, yerr=con_prob_good, capsize=2, markersize=5, color='#c51605')   # orange

    plt.plot(threshold, avg_prob_bad, linestyle='-', color='k', label='probabilistic (bad)', marker='x', markersize=7)  # blue 畫折線圖
    plt.errorbar(threshold, avg_prob_bad, yerr=con_prob_bad, capsize=2, markersize=5, color='k')   # blue 畫95%信賴區間

    plt.plot(threshold, avg_hist, linestyle='-', color='g', label='historic', marker='v', markersize=7)  # blue 畫折線圖
    plt.errorbar(threshold, avg_hist, yerr=con_hist, capsize=2, markersize=5, color='g')   # blue 畫95%信賴區間

    #plt.legend(loc='upper right')
    plt.legend(loc='best')

    plt.xlabel('Threshold_l value (s)')
    plt.ylabel('End-to-end Latency (s)')
    #plt.ylim(0, 21)
    plt.ylim(0, 14)
#    plt.title('End to end latency')
  #  plt.xticks(np.arange(0, 0.8, 0.1))  # x軸
#    y_ticks=np.arange(0,100,5)  
#    y_tick_labels = [str(i) if i % 10 == 0 else '' for i in y_ticks]
#    plt.yticks(y_ticks, y_tick_labels)  # y軸
#    plt.grid(True, linestyle='dotted', color='gray')    # 背景網狀線
    plt.tight_layout()
    plt.show()

main()



