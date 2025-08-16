# Aptos Bootcamp Pune

This project contains a Move smart contract and instructions for deploying and interacting with it on the Aptos blockchain.

## Project Structure

- `sources/` - Contains Move modules (e.g., `index.move`)
- `Move.toml` - Move package manifest

## Move Module: GrantTracker

Implements a grant system with milestones and payouts. Main entry functions:
- `create_grant` - Create a new grant with milestones
- `attest_and_payout_milestone` - Attest a milestone and pay the recipient

## Setup & Deployment

1. **Install Aptos CLI**
   - Download from: https://github.com/aptos-labs/aptos-core/releases
   - Add the CLI to your system PATH

2. **Configure Your Account**
   ```sh
   aptos init
   ```

3. **Build and Deploy**
   ```sh
   aptos move compile
   aptos move publish
   ```

4. **Edit Addresses**
   - Update `Move.toml` `[addresses]` section with your account address.

## Frontend (Optional)

You can build a React frontend using the Aptos JS SDK to interact with this contract. Example features:
- Connect Aptos wallet (e.g., Petra)
- Call contract entry functions
- Display transaction results

## Resources
- [Aptos Docs](https://aptos.dev/)
- [Move Book](https://move-language.github.io/move/)

---

For questions or contributions, open an issue or pull request.
