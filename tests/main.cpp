#include <iostream>
#include <random>
#include <vector>
#include <algorithm>
#include <chrono>

#include "../ClassA.h"

int main(int argc, char* argv[]) {
	ClassA classA;
	auto t1 = std::chrono::high_resolution_clock::now();
	std::vector<double> aValues;
        std::mt19937 mtre{123}; 
        std::uniform_real_distribution<double> distr_double{1.0, 100.0}; 
	std::uniform_int_distribution<int> distr_int{1, 20};
	for (int i = 0; i < 2000000; i++) {
        	double randomX = distr_double(mtre);
		double randomN = distr_int(mtre);	
		aValues.push_back(classA.FuncA(randomN, randomX)); 
    	}

        for (int i = 0; i < 500; i++) {
             	std::sort(begin(aValues), end(aValues));
        	std::reverse(begin(aValues), end(aValues));
        }

        auto t2 = std::chrono::high_resolution_clock::now();
        auto int_ms = std::chrono::duration_cast<std::chrono::milliseconds>(t2 - t1);

        int iMS = int_ms.count();
	if(iMS > 5000 && iMS < 20000){
	return 0;
	}	
	return 1;

}
