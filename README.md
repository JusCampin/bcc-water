# bcc-water

**bcc-water** is a comprehensive script for managing water interactions in RedM. It allows players to carry, drink, and refill a canteen, fill buckets and water bottles, as well as interact with various water sources. This script integrates seamlessly with multiple metabolism systems and enhances the player experience by adding realistic water-related activities.

## Features

- **Hydration Management**: Carry a canteen of water to drink and quench thirst.
- **Multi-Use Canteen**: Drink multiple times from a full canteen, with configurable usage limits.
- **Metabolism Integration**: Compatible with various metabolism scripts to manage thirst levels.
- **Water Source Interactions**:
  - Refill canteens, buckets and bottles at water pumps, sinks, rivers, and lakes.
  - Drink directly from natural water sources to preserve canteen water.
- **Health and Stamina Configurations**: Separate settings for drinking from canteens and wild waters.
- **Hygiene Options**: Players can wash in rivers, lakes, and at water pumps or sinks (soap item optional).
- **Risk Factor**: Players may get sick and perish after drinking wild water (even from a bottle).
- **Utility**: Fill water buckets and bottles for use in other scripts.

## Dependencies

- [vorp_core](https://github.com/VORPCORE/vorp-core-lua)
- [vorp_inventory](https://github.com/VORPCORE/vorp_inventory-lua)
- [bcc-utils](https://github.com/BryceCanyonCounty/bcc-utils)
- [feather-menu](https://github.com/FeatherFramework/feather-menu/releases/tag/1.2.0)

## Supported Metabolism Scripts

- VORP Metabolism
- Fred Metabolism
- Outsider Needs Metabolism
- RSD Metabolism
- NXT Metabolism
- Andrade Metabolism
- FX HUD
- Mega Metabolism
- POS Metabolism
- BLN HUD
- SS Metabolism
- BCC CoreHud
- CAS Metabolism

## Installation

- **Add Script to Resources**: Place the `bcc-water` folder in your resources directory.

- **Update `server.cfg`**: Add `ensure bcc-water` to your `server.cfg` file.

- **Script Load Order**: Ensure this script is loaded after your metabolism script and other dependencies.

- **Database Setup**: The resource includes a Lua seeder at `server/database.lua` which automatically seeds the required `items` rows on resource start (configurable). This replaces the old `water.sql` file.

  - To auto-seed on resource start, ensure `autoSeedDatabase = true` in `shared/configs/main.lua`.

  - To force a manual seed from the server console, run the command: `bcc-water:seed`.

  Verify seeded items

  - A console-only command `bcc-water:verify` is available to check the `items` table for the required items and report any missing entries.

- **Image Integration**: Copy images from the `img` folder to `...\vorp_inventory\html\img\items`.

- **Store/Crafting Setup**: Add items to a store or crafting station for player access.

- **Configuration**: Set your metabolism script in the `config/main.lua` file.

- **Restart Server**: Restart your server to apply the changes.

## Inspiration

- **green_canteen**: This script draws inspiration from the green_canteen script.

## GitHub Repository

- [bcc-water](https://github.com/BryceCanyonCounty/bcc-water)
