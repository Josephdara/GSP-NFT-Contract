// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IWhitelist{
    function whitelisted(address) external view returns (bool);
}