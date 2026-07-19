#include <iostream>
#include <fstream>
#include <thread>
#include <csignal>
#include <string>
#include <vector>

// bool is_full = false;
char path[]="/proc/stat";

struct proc_data {
    size_t user,nice,system,idle,iowait,irq,sortfitrq,steal;
    proc_data& operator-=(proc_data& a) {
        user-=a.user;
        nice-=a.nice;
        system-=a.system;
        idle-=a.idle;
        iowait-=a.iowait;
        irq-=a.irq;
        sortfitrq-=a.sortfitrq;
        steal-=a.steal;
        return *this;
    }
};

// void set_full(int sig) {
//     is_full = !is_full;
// }

std::vector<proc_data> parce_data(std::istream& is){
    std::vector<proc_data> v_data;
    std::string buffer;
    while(is>>buffer) {
        if (buffer == "intr") break;
        if (buffer.rfind("cpu", 0) != 0) continue;
        v_data.push_back({0,0,0,0,0,0,0,0});
        proc_data& now_data = v_data.back();
        is>>now_data.user>>now_data.nice>>now_data.system>>now_data.idle>>now_data.iowait>>now_data.irq>>now_data.sortfitrq>>now_data.steal;
        // if (!is_full) break;
    }
    is.clear();
    is.seekg(0, std::ios::beg);
    return v_data;
}
std::vector<uint8_t> parce_usage(std::istream& is){
    std::vector<uint8_t> v_out;
    std::vector<proc_data> v_data1, v_data2;
    v_data1 = parce_data(is);
    std::this_thread::sleep_for(std::chrono::seconds(1));
    v_data2 = parce_data(is);
    uint8_t size = std::min(v_data1.size(), v_data2.size());
    for(uint8_t i = 0; i < size; i++)
        v_data2[i]-=v_data1[i];
    for (proc_data& prc : v_data2) {
        prc.idle+=prc.iowait;
        prc.user+=prc.nice+prc.system+prc.irq+prc.sortfitrq+prc.steal;
        v_out.push_back(double(prc.user)/(prc.user+prc.idle)*100);
    }
    return v_out;
}

int main() {
    // std::signal(SIGUSR1, set_full);
    std::fstream proc_file(path, std::ios::in);
    while (true) {
        for (uint8_t i : parce_usage(proc_file)) {
            std::cout<<int(i)<<' ';
        }
        std::cout<<std::endl;
    }
    proc_file.close();
    return 0;
}
