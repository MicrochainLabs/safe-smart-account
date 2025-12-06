// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.7.0 <0.9.0;

/**
 * @title IERC8039
 * @notice ERC-8039: Standard Interface for Contract Proof Verification
 * @dev This interface standardizes proof verification for smart contracts,
 *      similar to how ERC-1271 standardizes signature verification.
 *      
 *      Contracts implementing this interface can act as "provers" in a Safe,
 *      providing ZK proofs or other cryptographic proofs instead of signatures.
 *      
 *      Signature Type: v = 2 in Safe's checkNSignatures
 *      Format:
 *        Static part (65 bytes):
 *          - r: prover contract address (left-padded to 32 bytes)
 *          - s: offset to proof data in signatures bytes
 *          - v: 2
 *        
 *        Dynamic part (at offset s):
 *          - data length (32 bytes)
 *          - abi.encode(bytes32[] publicInputs, bytes proof)
 */
interface IERC8039 {
    /**
     * @notice Verifies a proof with given public inputs
     * @dev MUST return the bytes4 magic value when the proof is valid.
     *      MUST NOT modify state (view function).
     *      MUST NOT revert if the proof is invalid, instead return 0x00000000 or any other value.
     *      
     *      Magic value: bytes4(keccak256("isValidProof(bytes32[],bytes)"))
     *      
     * @param publicInputs The public inputs to the proof (e.g., transaction hash, nullifiers, commitments)
     * @param proof The proof bytes (format depends on the proof system: Groth16, PLONK, STARK, etc.)
     * @return magicValue The bytes4 magic value if the proof is valid
     */
    function isValidProof(
        bytes32[] calldata publicInputs,
        bytes calldata proof
    ) external view returns (bytes4 magicValue);
}

/**
 * @title IERC8039Constants
 * @notice Constants for ERC-8039 proof verification
 */
abstract contract IERC8039Constants {
    /**
     * @dev bytes4(keccak256("isValidProof(bytes32[],bytes)"))
     */
    bytes4 internal constant ERC8039_MAGIC_VALUE = 0xe7927420;
}
