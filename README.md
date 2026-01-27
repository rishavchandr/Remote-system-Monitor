<img src="https://github.com/user-attachments/assets/499eb39a-21fe-4d70-b51c-1329f8d70cb6" width="100%" alt="Remote System Monitor Design Showcase">



# Remote System Monitor 🖥️📱

A professional-grade, full-stack solution to monitor your computer or home server's performance from anywhere in the world. This project bridges a **Node.js Backend**, a **SwiftUI Mobile App**, and a **Cross-Platform Monitoring Agent**.

---

## 🏗️ System Architecture

The project is divided into three core components:

1.  **The Agent (The Provider):** A lightweight Node.js script that runs on your target machine (Windows, Mac, or Linux). It uses the `systeminformation` library to pull hardware metrics.
2.  **The Server (The Brain):** A Node.js Express API that handles authentication, stores device data, and routes incoming performance streams.
3.  **The iOS App (The Visualizer):** A SwiftUI application that fetches data and creates high-performance reactive graphs using **SwiftCharts**.

---

## 🛠️ Tech Stack

* **iOS:** SwiftUI, SwiftCharts, Combine, URLSession.
* **Backend:** Node.js, Express, JWT (JSON Web Tokens), MongoDB/PostgreSQL.
* **Agent:** Node.js, [SystemInformation.io](https://systeminformation.io/).

---

## 🚀 Getting Started

### 1. Prerequisites
* **Node.js** (v16.x or higher) installed on your server and target PC.
* **Xcode 15+** (for iOS 16+ support).
* **MongoDB** (local or Atlas) for data storage.

### 2. Clone the Repository
```bash
git clone [https://github.com/yourusername/RemoteSystemMonitor.git](https://github.com/yourusername/RemoteSystemMonitor.git)
cd RemoteSystemMonitor