pragma circom 2.0.0;


include "../../node_modules/circomlib-ml/circuits/Conv2D.circom";
include "../../node_modules/circomlib-ml/circuits/Dense.circom";
include "../../node_modules/circomlib-ml/circuits/ArgMax.circom";
include "../../node_modules/circomlib-ml/circuits/Poly.circom";
include "../../node_modules/circomlib-ml/circuits/ReLU.circom";
include "./MaxPool2D.circom";


template cifar_net() {
    signal input in[32][32][3];

    signal input conv1_w[5][5][3][128];
    signal input conv1_b[128];

    signal input conv2_w[5][5][128][20];
    signal input conv2_b[20];

    signal input dense_w[500][10];
    signal input dense_b[10];
    signal output out;

    component conv1 = Conv2D(32,32,3,128,5);
    component relu1[28*28];
    component maxpool1[14*14];

    component conv2 = Conv2D(14,14,128,20,5);
    component relu2[10*10];
    component maxpool2[5*5];


    component dense = Dense(500,10);
    component argmax = ArgMax(10);

    // Let fill the weights of layers

    for (var cout = 0; cout < 128; cout++) {
        conv1.bias[cout] <== conv1_b[cout];
        for (var i=0; i<5; i++) {
            for (var j=0; j<5; j++) {
                for (var cin = 0; cin < 3; cin++) {
                    conv1.weights[i][j][0][0] <== conv1_w[i][j][0][0];
                }
            }
        }
    }

    for (var cout = 0; cout < 20; cout++) {
        conv2.bias[cout] <== conv2_b[cout];
        for (var i=0; i<5; i++) {
            for (var j=0; j<5; j++) {
                for (var cin = 0; cin < 128; cin++) {
                    conv2.weights[i][j][0][0] <== conv2_w[i][j][0][0];
                }
            }
        }
    }

    for (var cout = 0; cout < 10; cout++) {
        dense.bias[cout] <== dense_b[cout];
        for (var cin = 0; cin < 500; cin++) {
            dense.weights[i][j] <== dense_w[i][j];
        }
    }

    

    // put batch through the network

    for (var i = 0; i < 32; i++) {
        for (var j = 0; j < 32; j++) {
            for (var cin = 0; cin < 3; cin++) {
                conv1.in[i][j][cin] <== in[i][j][cin];
            }
        }
    }




}

component main = cifar_net();