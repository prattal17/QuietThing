#include <iostream>
#include <pigpio.h> // Pi GPIO library, needs to be installed on the compiling host

int main()
{
    if (gpioInitialise() >= 0)
        std::cout<< "Initialized gpio" << std::endl;
    else
        std::cout<< "Initialized gpio" << std::endl;

    return 0;
}