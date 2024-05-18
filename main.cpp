#include <iostream>

using namespace std;

int main(){
    int num = 7;
    int num1 = num + 3;
    int num2;
    cout << "Enter a number: ";
    cin >> num2;
    num2 += 10;
    cout << "Your secret is " << num2;
    return 0;
}