const chai = require("chai");
const { ethers } = require("hardhat");
const fs = require("fs");
const path = require("path");

const { groth16 } = require("snarkjs");
const wasm_tester = require("circom_tester").wasm;

const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
exports.p = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
const Fr = new F1Field(exports.p);

const assert = chai.assert;

const input_signals = require("./cifar_input.json");


describe("CIFAR Net test", function () {
    this.timeout(100000000);

    it("Test model on cifar10", async function () {
        console.log("start wasm_tester");
        const circuit = await wasm_tester(path.join(__dirname, "circuits", "cifar_model_test.circom"));
        console.log("finish wasm_tester");

        const deepMap=(input,callback)=>input.map(entry=>entry.map?deepMap(entry,callback):callback(entry));

        console.log('load data');
        const INPUT = {
            "in": deepMap(input_signals.in, Fr.e),
            // "conv1_b": deepMap(input_signals.conv1_b, Fr.e),
            // "conv2_w": deepMap(input_signals.conv2_w, Fr.e),
            // "conv2_b": deepMap(input_signals.conv2_b, Fr.e),
            // "dense_w": deepMap(input_signals.dense_w, Fr.e),
            // "dense_b": deepMap(input_signals.dense_b, Fr.e)
        }

        console.log("compute witness");
        // const witness = await circuit.calculateWitness(INPUT, true);

        // console.log(witness[1]);
    });
});