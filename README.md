# 🚚 Zerx-oxyruns | QBCore Oxy Delivery Script

A fully optimized and immersive oxy delivery job script for QBCore-based FiveM servers. Players can pick up packages from suppliers, deliver them to random locations, get paid, and receive bonus loot with built-in police checks, cooldown timers, and `interact` support.

---

## 📦 Features

- 💼 Start runs via NPC with optional start payment
- 📦 Collect packages from random supplier locations
- 🚗 Deliver packages to random buyer vehicles
- 🕵️ Requires police presence (customizable)
- ⏳ Cooldown system to prevent constant grinding
- 💰 Cash + item rewards, with chances for rare loot
- 🛰️ Custom blips and GPS routing
- 🔔 Supports both QBCore and phone notifications
- 🧠 Integrated with `interact` for cleaner performance
- 🧩 Fully configurable for blips, NPCs, vehicles & peds

---

## 📁 Installation

1. Place the `Zerx-oxyruns` folder inside your `resources` folder.
2. Add this to your `server.cfg`:
   ```cfg
   ensure Zerx-oxyruns

you can change the location of the ped in the config.lua



["oxypackage"] 				     = {["name"] = "oxypackage", 			 	    ["label"] = "Drugs Package", 		    ["weight"] = 5000, 	["type"] = "item", 		["image"] = "package.png", 				["unique"] = false, 		["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = ""},
