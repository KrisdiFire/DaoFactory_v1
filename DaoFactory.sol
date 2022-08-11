pragma ton-solidity >= 0.57.0;

pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "./DaoRoot.sol";
import "./structures/ProposalConfigurationStructure.sol";

contract DaoFactory {

    uint32 public nonce = 1;
    constructor() public {
        require(tvm.pubkey() != 0 && tvm.pubkey() == msg.pubkey(), 1001);
        tvm.accept();
    }

    //used for deploying new DAO
    //params:
    //platformCode_: code of the chosen platform
    //proposalConfiguration: Proposal configuration struct, includes neccessary data about proposal's voting delay, voting period, quorum votes, time lock, threshold, grace period
    //returns address of the deployed DAO
    function deploy(TvmCell platformCode_, ProposalConfigurationStructure.ProposalConfiguration proposalConfiguration_) external returns(address) {
        tvm.accept();

        address daoRoot = new DaoRoot {
            code: platformCode_,
            value: 1 ever,
            pubkey: 0,
            varInit: {
            	_nonce: nonce
            }
        }(platformCode_, proposalConfiguration_, address(this));
        ++nonce;
        return daoRoot;
    }
    
    //used for transfering gas from the contract to the gas reciever 
    //only owner can operate
    function withdrawGas(address gasTo) external pure onlyOwner {
        tvm.accept();
        gasTo.transfer({value: 0, flag: 128});
    }

    modifier onlyOwner {
        require(tvm.pubkey() != 0 && tvm.pubkey() == msg.pubkey(), 1001, "Only the owner can operate!");
        tvm.accept();
        _;
    }
}
