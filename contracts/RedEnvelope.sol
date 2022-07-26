// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RedEnvelope {
    uint envelopeCounter;
    struct Envelopes {
        uint tokenAmount;
        uint participantsLimit;
        uint participantsCounter;
        string message;
    }
    mapping(uint => Envelopes) envelope;

    constructor() {}

    /********************************************************
     *                                                      *
     *                     MAIN FUNCTIONS                   *
     *                                                      *
     ********************************************************/

    function createEnvelope(
        uint _tokenAmount,
        uint _participantsLimit,
        string memory _message
    ) external payable {
        envelopeCounter++;
        require(msg.value == _tokenAmount, "Insufficient funds");
        envelope[envelopeCounter].tokenAmount = _tokenAmount;
        envelope[envelopeCounter].participantsLimit = _participantsLimit;
        envelope[envelopeCounter].message = _message;
        //payable(address(this)).transfer(_tokenAmount);
    }

    function claim(uint _envelopeId) external payable {
        Envelopes storage _envelope = envelope[_envelopeId];
        require(
            _envelope.participantsLimit > _envelope.participantsCounter,
            "max participants exceeded"
        );
        require(_envelope.tokenAmount > 0, "tokens already distributed");
        _envelope.participantsCounter++;
        uint _amountToDeliver;
        if (_envelope.participantsLimit != _envelope.participantsCounter) {
            _amountToDeliver =
                (uint(
                    keccak256(
                        abi.encodePacked(
                            _envelope.participantsCounter,
                            block.timestamp
                        )
                    )
                ) % _envelope.tokenAmount) +
                1;
        } else {
            _amountToDeliver = _envelope.tokenAmount;
        }
        _envelope.tokenAmount -= _amountToDeliver;
        //payable(msg.sender).transfer(_amountToDeliver);
        (bool sent, ) = payable(msg.sender).call{value: _amountToDeliver}("");
        require(sent, "Failed to send Ether");
    }

    function readcontractBalance() external view returns (uint) {
        return address(this).balance;
    }
}

/********************************************************
 *                                                      *
 *                     OLD FUNCTIONS                   *
 *                                                      *
 ********************************************************/
// 	function createEnvelope(uint _tokenAmount, uint _participantsLimit) external payable{
// 		envelopeCounter++;
//     require(msg.value == _tokenAmount, "Insufficient funds");
//     envelope[envelopeCounter].tokenAmount = _tokenAmount;
//     envelope[envelopeCounter].participantsLimit = _participantsLimit;
// 	}

//   function claim(address _claimer, uint _envelopeId) external {
//     Envelopes storage _envelope = envelope[_envelopeId];
//     require(_envelope.participantsLimit >  _envelope.participantsCounter, "max participants exceeded");
//     require(_envelope.tokenAmount > 0, "tokens already distributed");
//     _envelope.participantsCounter++;
//     uint _amountToDeliver;
//     if(_envelope.participantsLimit != _envelope.participantsCounter) {
//       _amountToDeliver = (uint(keccak256(abi.encodePacked(_envelope.participantsCounter,block.timestamp))) % _envelope.tokenAmount) + 1;
//     } else {
//       _amountToDeliver = _envelope.tokenAmount;
//     }
//     _envelope.tokenAmount -= _amountToDeliver;
//     payable(_claimer).transfer(_amountToDeliver);
//   }
// }
