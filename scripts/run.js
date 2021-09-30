

const main = async() => {
    const nftContractFactory = await hre.ethers.getContractFactory("DopeNft");
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("contract deployed to:",nftContract.address);

    let tranx = await nftContract.constructDopeNft();
    await tranx.wait();

    tranx = await nftContract.constructDopeNft();
    await tranx.wait();
    
    tranx = await nftContract.constructDopeNft();
    await tranx.wait();
};

const runMain = async ()=>{
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();