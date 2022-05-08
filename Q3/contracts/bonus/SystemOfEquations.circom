pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib-matrix/circuits/matElemMul.circom"; // hint: you can use more than one templates in circomlib-matrix to help you
include "../../node_modules/circomlib-matrix/circuits/matElemSum.circom";

template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution

    // [bonus] insert your code here

    component mul = matElemMul(3,n);
    for (var i=0; i<3; i++) {
        for (var j=0; j<n; j++) {
            mul.a[i][j] <== A[i][j];
            mul.b[i][j] <== x[j];
        }
    }

    var tmp;
    component sum[n];
    component eqs[n];
    for (var j=0; j<n; j++) {
        sum[j] = matElemSum(3, 1);
        for (var i=0; i<3; i++) {
            sum[j].a[i][0] <== mul.out[i][j];
        }
        eqs[j] = IsEqual();
        eqs[j].in[0] <== sum[j].out;
        eqs[j].in[1] <== x[j];
        tmp = tmp * eqs[j].out;
    }

    out <-- tmp;
}

component main {public [A, b]} = SystemOfEquations(3);