const { deployments, getNamedAccounts } = require("hardhat");

async function main() {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  console.log("Deploying PaymentSystem...");

  const bookingService = (await deployments.get("BookingService")).address; // Retrieve the BookingService address
  const maticTokenAddress = "0x0000000000000000000000000000000000001010"; // Replace with the actual address of the Matic token

  await deploy("PaymentSystem", {
    from: deployer,
    args: [maticTokenAddress, bookingService],
  });

  console.log("PaymentSystem deployed to:", (await deployments.get("PaymentSystem")).address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
