# 🛡️ AI Server Technician & Self-Healing Monitor

This is an advanced **n8n workflow** that acts as an automated Sysadmin for your Home Lab. 

Unlike standard uptime monitors (like Uptime Kuma) which only tell you *when* something is down, this workflow:
1. **Detects** the outage.
2. **Attempts to Fix It** via SSH (restarting the specific Docker container).
3. **Analyzes the Error** using Google Gemini AI to explain *why* the HTTP code occurred.
4. **Verifies the Fix** and updates the status.
5. **Logs Everything** to Google Sheets for historical uptime tracking.

## 🚀 Features
- **Smart Monitoring:** Checks HTTP status codes for a list of targets.
- **Self-Healing:** Automatically SSHs into the host and runs `docker restart <container_name>` if a service fails.
- **AI Diagnostics:** Uses Google Gemini to explain HTTP error codes in plain English.
- **State Management:** Tracks "Previous Status" vs "Current Status" to prevent alert fatigue (only alerts on Change of State).
- **Discord Alerts:** Sends rich embed notifications for downtime and recovery.

## 📋 Prerequisites

To use this workflow, you need:
1. **n8n** (Self-hosted).
2. **Google Cloud Console** project with Sheets API enabled.
3. **Google Gemini API Key** (Free tier works for this volume).
4. **Discord Webhook URL**.
5. **SSH Access** to your Docker host (Key-based auth recommended).

## ⚙️ Configuration

### 1. The Google Sheet (CRITICAL)
This workflow relies on a Google Sheet to read targets and log results. You must create a sheet with two tabs:

**Tab 1 Name:** `Targets`
| Column Header | Description | Example |
| :--- | :--- | :--- |
| **Name** | The friendly name of the service | `Plex Media Server` |
| **URL** | The internal/external URL to check | `http://192.168.1.50:32400` |
| **Container_Name** | The exact Docker container name for restarts | `plex` |
| **Active_Monitoring** | Checkbox or TRUE/FALSE | `TRUE` |
| **Current_Status** | (Leave Empty - populated by n8n) | |
| **Last_Checked** | (Leave Empty - populated by n8n) | |

**Tab 2 Name:** `Logs`
| Column Header | Description |
| :--- | :--- |
| **Timestamp** | Date of the log |
| **Target_Name** | Name of the service |
| **URL** | The URL checked |
| **Status_Code** | The HTTP code received |
| **Outcome** | "Active" or "DOWN" |

### 2. Environment Variables / Credentials
Import the JSON file into n8n and set up the following credentials:
- **Google Sheets OAuth2 API**
- **SSH Password / Key** (For the Docker host)
- **Google Gemini (PaLM) API**
- **Discord Webhook URL** (Paste into the HTTP Request node or use credentials)

## 🔮 Roadmap / Future Plans
- [ ] Add support for Portainer API (instead of raw SSH).
- [ ] Add Telegram notifications as an alternative to Discord.
- [ ] Create a dashboard for uptime statistics using the Google Sheet data.

## ⚠️ Disclaimer
This workflow executes `docker restart` commands via SSH. Ensure the user account used for SSH has the appropriate permissions to manage docker containers (e.g., belongs to the `docker` group).
