#include <iostream>
#include <thread>
#include <chrono>
#include <string>

std::chrono::milliseconds time_duration = std::chrono::milliseconds(75);
std::string V[] = {"\u1488","\u1489","\u148A", "\u148B", "\u148C"};

int main(const int argc, char* argv[]){
    if (argc > 0) {
        if (argc != 2 || !argv || !argv[1]) {
            std::cerr << "ERRO! Unorgonize argument." << std::endl;
            return -1;
        }
        time_duration = std::chrono::milliseconds(std::stoi(argv[1]));
    }
    while(true)
        for (const std::string& i : V){
            std::cout << '\r' << i << std::flush;
            std::this_thread::sleep_for(time_duration);
        }
    return 0;
}
