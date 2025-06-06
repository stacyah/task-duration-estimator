# Time Helper – C964 Capstone

Time Helper is a task duration predictor built for WGU’s C964 Capstone. It helps IT teams plan daily work more accurately by learning from past task logs. 

Deployed Version: [https://stacyhilliard.me](https://stacyhilliard.me)

## Features

- Predicts task time based on CSV history
- Live countdown timer per task
- Plotly charts to show prediction accuracy
- Flask + JS stack, no database needed

## Run using Docker

```bash
docker build -t time-helper .
docker run -d -p 5000:5000 time-helper
```