const { expect } = require('chai');
const { ethers } = require('hardhat');

const tokens = (n) => {
  return ethers.utils.parseUnits(n.toString(), 'ether')
}

const ether = tokens

describe('FlashLoan', () => {
    
    beforeEach(async () => {
        // Load accounts
        const FlashLoan = await ethers.getContractFactory('FlashLoan')
        const FlashLoanReceiver = await ethers.getContractFactory('FlashLoanReceiver')
        const Token = await ethers.getContractFactory('Token')

    })

    describe('Deployment', () => {

    })
})
