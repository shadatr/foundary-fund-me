// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "./MockV3Aggregator.sol";

contract HelperConfig is Script{
    NetWorkConfig public activeNetWorkConfig;
    uint8 public constant DECIMAL=8;
    int256 public constant INITIAL_PRICE=8;

    struct NetWorkConfig {
        address priceFeed;
    }
    constructor (){
        if(block.chainid==11155111){
            activeNetWorkConfig= getSepoliaEthConfig();
        }else if(block.chainid==1){
            activeNetWorkConfig=getMainnetEthConfig();
        }else{
            activeNetWorkConfig=getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns(NetWorkConfig memory){
        NetWorkConfig memory sepoliaEthConfig= NetWorkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaEthConfig;
    }

    function getMainnetEthConfig() public pure returns(NetWorkConfig memory){
        NetWorkConfig memory mainnetEthConfig= NetWorkConfig({priceFeed: 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e});
        return mainnetEthConfig;
    }

    function getAnvilEthConfig() public returns (NetWorkConfig memory){
        if(activeNetWorkConfig.priceFeed!=address(0)){
            return activeNetWorkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMAL,INITIAL_PRICE );
        vm.stopBroadcast();

        NetWorkConfig memory anvilConfig= NetWorkConfig({priceFeed:address(mockPriceFeed)});
        return anvilConfig;
    }
}