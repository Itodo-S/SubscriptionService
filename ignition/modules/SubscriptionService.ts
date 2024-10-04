import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { ethers } from "hardhat";

const ownerAddress = process.env.OWNER_ADDRESS;
const subscriptionFee = ethers.parseEther("0.01");

const SubscriptionServiceModule = buildModule("SubscriptionServiceModule", (m) => {
    // Pass the constructor arguments (owner address and subscription fee)
    const SubscriptionService = m.contract("SubscriptionService", [ownerAddress, subscriptionFee]);

    return { SubscriptionService };
});

export default SubscriptionServiceModule;
