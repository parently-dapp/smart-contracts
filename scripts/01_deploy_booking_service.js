const { deployments, getNamedAccounts } = require("hardhat");

async function main() {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  console.log("Deploying BookingService...");

  await deploy("BookingService", {
    from: deployer,
  });
  
  console.log("BookingService deployed to:", (await deployments.get("BookingService")).address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
