#!/bin/bash

cd contracts/circuits

mkdir Conv2d

if [ -f ./powersOfTau28_hez_final_15.ptau ]; then
    echo "powersOfTau28_hez_final_15.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_15.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_15.ptau
fi

echo "Compiling Conv2d.circom..."

# compile circuit

circom Conv2d.circom --r1cs --wasm --sym -o Conv2d
snarkjs r1cs info Conv2d/Conv2d.r1cs

# Start a new zkey and make a contribution

snarkjs groth16 setup Conv2d/Conv2d.r1cs powersOfTau28_hez_final_15.ptau Conv2d/circuit_0000.zkey
snarkjs zkey contribute Conv2d/circuit_0000.zkey Conv2d/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey Conv2d/circuit_final.zkey Conv2d/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier Conv2d/circuit_final.zkey ../Conv2dVerifier.sol

cd ../..