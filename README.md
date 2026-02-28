![sys-remote-design](https://github.com/user-attachments/assets/b9b42a14-6f58-43e3-9bc0-323880b19719)


# Remote System Monitor 🖥️📱

A professional-grade, full-stack solution to monitor your computer or home server's performance from anywhere in the world. This project bridges a **Node.js Backend**, a **SwiftUI Mobile App**, and a **Cross-Platform Monitoring Agent**.

---

## 🏗️ System Architecture

The project is divided into three core components:

1. **The Agent (The Provider):** A lightweight Node.js script that runs on your target machine (Windows, Mac, or Linux). It uses the `systeminformation` library to pull hardware metrics.
2. **The Server (The Brain):** A Node.js Express API that handles authentication, stores device data, and routes incoming performance streams.
3. **The iOS App (The Visualizer):** A SwiftUI application that fetches data and creates high-performance reactive graphs using **SwiftCharts**.

---

## 🛠️ Tech Stack

* **iOS:** SwiftUI, SwiftCharts, Combine, URLSession
* **Backend:** Node.js, Express, JWT (JSON Web Tokens), MongoDB
* **Agent:** Node.js, [SystemInformation.io](https://systeminformation.io/)

---

## 🚀 Getting Started

### 1. Prerequisites

* **Node.js** (v16.x or higher) installed on your server and target PC
* **Xcode 15+** (for iOS 16+ support)
* **MongoDB** (local or Atlas) for data storage
* **npm** or **yarn** package manager

### 2. Clone the Repository

```bash
git clone https://github.com/rishavchandr/Remote-sys-Monitor.git
cd Remote-sys-Monitor
```

---

## 🖥️ Backend Setup

### 1. Navigate to Backend Directory

```bash
cd backend
```

### 2. Install Dependencies

```bash
npm installl
```

### 3. Configure Environment Variables

Create a `.env` file in the `backend` directory:

```env
PORT=3000
MONGODB_URI=mongodb://username:password@cluster0.texturl.mongo.net
JWT_SECRET=your_super_secret_jwt_key_change_this
JWT_EXPIRY = 7d
```

### 4. Run the Backend Server

**Development Mode:**
```bash
npm run dev
```

The server will start on `http://localhost:3000` (or your configured port).

---

## 🤖 Agent Setup

### 1. Navigate to Agent Directory

```bash
cd agent
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Run the Agent

**Start Monitoring:**
```bash
npm run start
```

The agent will now continuously send system metrics to your backend server.

---

## 📱 iOS App Installation

### 1. Open the iOS Project

```bash
cd ios
open RemoteSystemMonitor.xcodeproj
```

### 2. Configure API Endpoint

In `Content The instruction Given` (or your configuration file), update the backend URL:

```swift
struct APIConfig {
    static let baseURL = "http://your-server-ip:3000/api"
}
```

### 3. Build and Run

1. Select your target device or simulator in Xcode
2. Click the **Run** button (⌘R) or navigate to **Product → Run**
3. The app will install and launch on your device

### 4. Login to Your Device

1. Enter your device credentials or JWT token
2. View real-time system metrics with beautiful charts

---

## ✨ Features

### 📊 Real-Time Monitoring
* **CPU Usage:** Monitor processor load across all cores
* **Memory Usage:** Track RAM consumption and availability
* **Disk I/O:** Monitor read/write speeds and disk utilization
* **Network Traffic:** Real-time upload/download bandwidth monitoring
* **Temperature Sensors:** CPU and GPU temperature tracking (where available)

### 🔒 Secure Authentication
* JWT-based authentication for all API requests
* Device-level access control
* Encrypted data transmission

### 📈 Advanced Visualization
* **SwiftCharts Integration:** Smooth, animated line graphs
* **Live Updates:** Charts update in real-time as new data arrives
* **Historical Data:** View performance trends over time
* **Multi-Device Support:** Monitor multiple computers from one app

### 🔔 Alert System
* Customizable threshold alerts (CPU > 80%, Memory > 90%, etc.)
* Push notifications for critical system events
* Email alerts for extended monitoring

### 🌐 Cross-Platform Agent
* Works on **Windows**, **macOS**, and **Linux**
* Minimal resource footprint (<50MB RAM)
* Automatic reconnection on network interruptions

---

## 📊 Expected Results

### What You'll See in the App

1. **Dashboard Overview**
   * Summary cards showing current CPU, RAM, Disk, and Network usage
   * Device status indicators (online/offline)
   * Last updated timestamp

2. **Detailed Metrics View**
   * CPU usage broken down by core
   * Memory consumption with swap usage
   * Disk read/write operations per second
   * Network throughput in real-time

3. **Performance Graphs**
   * Historical charts showing performance trends
   * Customizable time ranges (1 hour, 24 hours, 7 days)
   * Zoom and pan capabilities

4. **System Information**
   * OS version and architecture
   * Hardware specifications (CPU model, RAM capacity)
   * Uptime and boot time
   * Installed storage devices

---

## 🐛 Troubleshooting

### Agent Connection Issues
* Verify the API URL configuration is correct
* Ensure the backend server is running and accessible
* Check firewall settings on both server and agent machines

### iOS App Not Receiving Data
* Confirm the device token is valid
* Check network connectivity on your iOS device
* Verify the API endpoint URL in the app configuration

### High Resource Usage
* Increase the update interval in agent configuration
* Reduce the data retention period in backend settings

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🔗 Links

* **GitHub Repository:** https://github.com/rishavchandr/Remote-sys-Monitor
* **Documentation:** [Wiki](https://github.com/rishavchandr/Remote-sys-Monitor/wiki)
* **Issue Tracker:** [Issues](https://github.com/rishavchandr/Remote-sys-Monitor/issues)

---

## 📧 Contact

For questions or support, please open an issue on GitHub or contact the maintainers.

---

**Built with ❤️ by the Remote System Monitor Team**
