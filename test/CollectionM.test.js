const { expect } = require("chai");
let owner, collectionM
describe("Token contract", function () {
	before ( async () => {
		[owner] = await ethers.getSigners()
		const CollectionM = await ethers.getContractFactory("CollectionM");
		collectionM = await CollectionM.deploy("ipfs://QmTf1GaD7j9FYZzo9RUSUkHB9oLkNAZrFQB1aPrsGzWn1d",10,owner.address,1)
	})

  it("Base token URI is correct", async function () {
    expect(await collectionM.baseURI()).to.equal("ipfs://QmTf1GaD7j9FYZzo9RUSUkHB9oLkNAZrFQB1aPrsGzWn1d")
		expect(await collectionM.NFTQuantity()).to.equal("10")
  })

	it("Cannot mint with insufficient funds", async() => {
		await expect(
			collectionM.mint({value: 0})
		).to.be.revertedWith("Token Collection: insufficient funds")
	})

	it("Tokens mint is correct", async() => {
		let currentMintedToken
		for(var i = 1; i <= 10; i ++) {
			await collectionM.mint({value: 2})
			currentMintedToken = await collectionM.tokenURI(i)
			expect(await currentMintedToken).to.equal("ipfs://QmTf1GaD7j9FYZzo9RUSUkHB9oLkNAZrFQB1aPrsGzWn1d"+"/"+i+".json")
		}
	})

	it("Cannot mint more tokens than total supply", async() => {
		await expect(
			collectionM.mint({value: 2})
		).to.be.revertedWith("Token Collection: sold out")
	})

})