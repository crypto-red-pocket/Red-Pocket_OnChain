const { expect } = require("chai");
let owner, storageAlert, notWriter
describe("Token contract", function () {
	before ( async () => {
		[owner, notWriter] = await ethers.getSigners()
		const StorageAlert = await ethers.getContractFactory("StorageAlert");
		storageAlert = await StorageAlert.deploy()
	})

  it("Data storage is correct", async function () {
    await storageAlert.createAlert("MDMA", "H2O", "Barcelona","Hard headaches",43124312)
    let alert = await storageAlert.getAlert(1)
    expect(await alert.name).to.equal("MDMA")
    expect(await alert.composition).to.equal("H2O")
    expect(await alert.location).to.equal("Barcelona")
    expect(await alert.timeStamp).to.equal("43124312")
    expect(await alert.comment).to.equal("Hard headaches")
  })

  it("Cannot store alerts with insufficient rights", async()=> {
    await expect(
			storageAlert.connect(notWriter).createAlert("MDMA", "H2O", "Barcelona","Hard headaches",43124312)
		).to.be.revertedWith("Not writer")
  })

})