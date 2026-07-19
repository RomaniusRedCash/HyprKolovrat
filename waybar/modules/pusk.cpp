#include <iostream>
#include <array>
#include <thread>
#include <chrono>
#include <string>

std::chrono::milliseconds time_out = std::chrono::milliseconds(75);
std::array<std::string, 5> V = {"\u1488","\u1489","\u148A", "\u148B", "\u148C"};

int main(){
    while(true)
    for (const std::string& i : V){
        std::cout<<"{\"text\":\""<<i<<"\"}"<<std::endl;
        std::this_thread::sleep_for(time_out);
    }

    return 0;
}
