# Monitoring & Alerting

This document describes the monitoring and alerting setup for both AWS and Azure deployments.

## AWS CloudWatch

### Metrics Monitored

**ECS Services:**
- CPU Utilization (Backend & Frontend)
- Memory Utilization (Backend & Frontend)

**Application Load Balancer:**
- Target Response Time
- Unhealthy Target Count
- Request Count

### Alarms Configured

| Alarm | Threshold | Evaluation Period | Action |
|-------|-----------|-------------------|--------|
| Backend CPU High | > 70% | 10 minutes (2x5min) | SNS Email |
| Backend Memory High | > 80% | 10 minutes (2x5min) | SNS Email |
| Frontend CPU High | > 70% | 10 minutes (2x5min) | SNS Email |
| Frontend Memory High | > 80% | 10 minutes (2x5min) | SNS Email |
| ALB Response Time High | > 2 seconds | 10 minutes (2x5min) | SNS Email |
| Unhealthy Targets | > 0 | 1 minute | SNS Email |

### CloudWatch Dashboard

A custom dashboard is created showing:
- ECS CPU Utilization (Backend & Frontend)
- ECS Memory Utilization (Backend & Frontend)
- ALB Request Count
- ALB Response Time

**Access Dashboard:**
```bash
# Get dashboard URL
echo "https://console.aws.amazon.com/cloudwatch/home?region=ap-south-1#dashboards:name=devops-prod-dashboard"
```

### Setting Up Email Alerts

1. After `terraform apply`, check your email for SNS subscription confirmation
2. Click "Confirm subscription" in the email
3. You'll start receiving alerts when thresholds are breached

## Azure Monitor

### Metrics Monitored

**Container Apps:**
- CPU Usage (Nano Cores)
- Memory Usage (Working Set Bytes)
- Request Count

### Alerts Configured

| Alert | Threshold | Evaluation Period | Action |
|-------|-----------|-------------------|--------|
| Backend CPU High | > 70% (350M nanocores) | 15 minutes | Email |
| Backend Memory High | > 80% (858MB) | 15 minutes | Email |
| High Request Count | > 1000 requests | 15 minutes | Email |

### Log Analytics

All container logs are sent to Log Analytics workspace for:
- Application logs
- System logs
- Performance metrics

**Query Logs:**
```bash
# Get workspace ID
az monitor log-analytics workspace show \
  --resource-group devops-prod-rg \
  --workspace-name devops-prod-logs \
  --query customerId -o tsv
```

**Access Logs in Portal:**
1. Go to Azure Portal → Log Analytics workspaces
2. Select `devops-prod-logs`
3. Click "Logs" and run queries

**Sample Queries:**

```kusto
// Backend errors in last hour
ContainerAppConsoleLogs_CL
| where ContainerAppName_s == "devops-prod-backend"
| where Log_s contains "error"
| where TimeGenerated > ago(1h)
| project TimeGenerated, Log_s

// Request count by status code
ContainerAppConsoleLogs_CL
| where TimeGenerated > ago(1h)
| summarize count() by StatusCode_s
```

### Setting Up Email Alerts

Email alerts are automatically configured via Action Group. Check your email for any alert notifications.

## Testing Alerts

### AWS

**Trigger CPU Alert:**
```bash
# Stress test backend
for i in {1..1000}; do
  curl http://YOUR_ALB_DNS/api/message &
done
```

**Trigger Unhealthy Target Alert:**
```bash
# Stop a task
aws ecs stop-task --cluster devops-prod-cluster --task TASK_ID --region ap-south-1
```

### Azure

**Trigger CPU Alert:**
```bash
# Stress test backend
for i in {1..1000}; do
  curl https://YOUR_BACKEND_URL/api/message &
done
```

## Viewing Metrics

### AWS CloudWatch Console

```bash
# Open CloudWatch console
echo "https://console.aws.amazon.com/cloudwatch/home?region=ap-south-1"
```

Navigate to:
- **Dashboards** → `devops-prod-dashboard`
- **Alarms** → View all configured alarms
- **Logs** → `/ecs/devops-prod-backend` and `/ecs/devops-prod-frontend`

### Azure Portal

```bash
# Open Azure Portal
echo "https://portal.azure.com"
```

Navigate to:
- **Monitor** → **Alerts** → View all alerts
- **Monitor** → **Metrics** → Select Container App
- **Log Analytics workspaces** → `devops-prod-logs`

## Cost

**AWS:**
- CloudWatch Alarms: $0.10/alarm/month (6 alarms = $0.60/month)
- CloudWatch Dashboard: $3/month
- CloudWatch Logs: First 5GB free, then $0.50/GB
- **Total: ~$4/month**

**Azure:**
- Monitor Alerts: First 10 alerts free
- Log Analytics: First 5GB free, then $2.30/GB
- **Total: ~$0-2/month**

## Best Practices

1. ✅ Set appropriate thresholds based on baseline metrics
2. ✅ Use evaluation periods to avoid false positives
3. ✅ Configure multiple notification channels (email, Slack, PagerDuty)
4. ✅ Review and adjust thresholds regularly
5. ✅ Set up log retention policies to control costs
6. ✅ Use dashboards for quick health checks
7. ✅ Enable Container Insights (AWS) / Application Insights (Azure) for deeper visibility
