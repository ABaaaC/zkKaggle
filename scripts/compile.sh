#!/bin/bash

cd contracts/circuits

mkdir cifar_net

if [ -f ./powersOfTau28_hez_final_25.ptau ]; then
    echo "powersOfTau28_hez_final_25.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_25.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_25.ptau
fi

echo "Compiling cifar_net2.circom..."

# compile circuit

# circom cifar_net.circom --r1cs --wasm --sym -o cifar_net
# circom cifar_net2.circom --r1cs -c --sym -o cifar_net
echo "circom done..."
snarkjs r1cs info cifar_net/cifar_net2.r1cs

# Start a new zkey and make a contribution

snarkjs groth16 setup cifar_net/cifar_net2.r1cs powersOfTau28_hez_final_25.ptau cifar_net/circuit_0000.zkey
snarkjs zkey contribute cifar_net/circuit_0000.zkey cifar_net/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey cifar_net/circuit_final.zkey cifar_net/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier cifar_net/circuit_final.zkey ../cifar_netVerifier.sol

cd ../..