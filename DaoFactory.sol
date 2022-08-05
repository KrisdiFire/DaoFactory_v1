pragma ton-solidity >= 0.57.0;

pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "./DaoRoot.sol";
import "./structures/ProposalConfigurationStructure.sol";

contract DaoFactory {

    constructor() public {
        require(tvm.pubkey() != 0 && tvm.pubkey() == msg.pubkey(), 1001);
        tvm.accept();
    }

    function deploy(TvmCell platformCode_, ProposalConfigurationStructure.ProposalConfiguration proposalConfiguration_) external returns(address) {
        tvm.accept();

        address daoRoot = new DaoRoot {
            code: platformCode_,
            value: 1 ever,
            pubkey: 0,
            varInit: {}
        }(platformCode_, proposalConfiguration_, address(this));
        return daoRoot;
    }

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
