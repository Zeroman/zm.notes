/// @file test.cpp
/// @brief 
/// @author Zeroman Yang <51feel@gmail.com>
/// 0.01
/// @date 2015-10-19


#include <iostream>

class Hello {
public: 
    void sayHello() {
        std::cout << "Hello world" << std::endl;
    }
};

int main(int argc, char const* argv[])
{
    Hello hello;

    hello.sayHello();

    return 0;
}
