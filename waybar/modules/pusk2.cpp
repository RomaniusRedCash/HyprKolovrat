#include <iostream>
#include <thread>
#include <chrono>
#include <string>

std::chrono::milliseconds time_out = std::chrono::milliseconds(75);
std::string start_s = "\u1488";
int main(){
    while(true)
    for (char i = 0; ; i++){
        i %= 5;
        std::string s = start_s;
        s.back()+=i;

        std::cout<<s<<std::endl;
        std::this_thread::sleep_for(time_out);
    }

    return 0;
}
