# Time Helper

Time Helper is a web application that uses historical data to predict task completion times, helping teams improve their planning accuracy.  

Deployed Version: [https://stacyhilliard.me](https://stacyhilliard.me)

## Features

- Predicts task time based on CSV history
- Live countdown timer per task
- Plotly charts to show prediction accuracy
- Flask + JS stack, no database needed

## Tech Stack & Key Skills

**Application:** Python, Flask, Pandas, Plotly.js
**Containerization:** Docker
**Cloud Provider:** Amazon Web Services (AWS)
**Infrastructure as Code:** Terraform
**Configuration Management & Automation:** Ansible

## Running Locally

```bash
docker build -t time-helper .
docker run -d -p 5000:5000 time-helper
```