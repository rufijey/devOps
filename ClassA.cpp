#include "ClassA.h"
#include <cmath>

/**
 * @param n Number of terms to sum.
 * @param x Common ratio of the geometric series.
 * @return The sum of the first n terms.
 */

double ClassA::FuncA(int n, double x) {
	double sum = 0.0;
       	for (int i = 0; i < n; ++i) {
		sum += pow(x, i);
    	}
    	return sum;
}
