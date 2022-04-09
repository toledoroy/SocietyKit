//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;    //https://docs.soliditylang.org/en/v0.5.2/abi-spec.html?highlight=abiencoderv2

// import "hardhat/console.sol";

import "@openzeppelin/contracts/utils/Counters.sol";
import "../interfaces/IRules.sol";
import "../interfaces/IActionRepo.sol";
import "../libraries/DataTypes.sol";


/**
 * @title Rules Contract 
 * @dev To Extend or Be Used by Jurisdictions
 * - Hold, Update, Delete & Serve Rules
 * - Single immutable Action Repo
 */
// abstract contract Rules is IRules, Opinions {
contract Rules is IRules {
    
    //--- Storage

    using Counters for Counters.Counter;
    Counters.Counter private _ruleIds;
    //Action Repository Contract (HISTORY)
    IActionRepo internal _actionRepo;   
    //Rule Data
    mapping(uint256 => DataTypes.Rule) internal _rules;
    //Additional Rule Data
    mapping(uint256 => DataTypes.Confirmation) internal _ruleConfirmation;
    // mapping(uint256 => string) internal _uri;

    //--- Functions

    constructor(address actionRepo_) {
        _setActionsContract(actionRepo_);
    }

    /// Get Rule
    function ruleGet(uint256 id) public view override returns (DataTypes.Rule memory) {
        return _rules[id];
    }

    /// Set Actions Contract
    function _setActionsContract(address actionRepo_) internal {
        require(address(_actionRepo) == address(0), "HISTORY Contract Already Set");
        //String Match - Validate Contract's Designation        //TODO: Maybe Look into Checking the Supported Interface
        require(keccak256(abi.encodePacked(IActionRepo(actionRepo_).symbol())) == keccak256(abi.encodePacked("YJ_HISTORY")), "Expecting HISTORY Contract");
        //Set
        _actionRepo = IActionRepo(actionRepo_);
        //Event
        emit ActionRepoSet(actionRepo_);
    }

    /// Expose Action Repo Address
    function actionRepo() external view override returns (address) {
        return address(_actionRepo);
    }

    /// Add Rule
    function _ruleAdd(DataTypes.Rule memory rule) internal returns (uint256) {
        //Add New Rule
        _ruleIds.increment();
        uint256 id = _ruleIds.current();
        //Set
        _rules[id] = rule;
        //Event
        emit Rule(id, rule.about, rule.affected, rule.uri, rule.negation);
        emit RuleEffects(id, rule.effects.environmental, rule.effects.personal, rule.effects.social, rule.effects.professional);
        return id;
    }

    /// Remove Rule
    function _ruleRemove(uint256 id) internal {
        delete _rules[id];
        //Event
        emit RuleRemoved(id);
    }

    /// Update Rule
    function _ruleUpdate(uint256 id, DataTypes.Rule memory rule) internal {
        //Set
        _rules[id] = rule;
        //Event
        emit Rule(id, rule.about, rule.affected, rule.uri, rule.negation);
        emit RuleEffects(id, rule.effects.environmental, rule.effects.personal, rule.effects.social, rule.effects.professional);
    }

    /// Get Rule's Confirmation Method
    function confirmationGet(uint256 id) public view override returns (DataTypes.Confirmation memory){
        return _ruleConfirmation[id];
    }

    /// Update Confirmation Method for Action
    function confirmationSet(uint256 id, DataTypes.Confirmation memory confirmation) external override {
        //TODO: Validate Caller's Permissions
        _confirmationSet(id, confirmation);
    }
    
    /// Set Action's Confirmation Object
    function _confirmationSet(uint256 id, DataTypes.Confirmation memory confirmation) internal {
        _ruleConfirmation[id] = confirmation;
        emit Confirmation(id, confirmation.ruling, confirmation.evidence, confirmation.witness);
    }


}
